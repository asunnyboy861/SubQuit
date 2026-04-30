import Foundation
import SwiftData

@Observable
final class SavingsCalculator {

    func totalMonthlySpent(subscriptions: [Subscription]) -> Decimal {
        subscriptions.filter(\.isActive).reduce(0) { $0 + monthlyEquivalent(of: $1) }
    }

    func totalYearlySpent(subscriptions: [Subscription]) -> Decimal {
        totalMonthlySpent(subscriptions: subscriptions) * 12
    }

    func totalSaved(subscriptions: [Subscription]) -> Decimal {
        subscriptions.filter(\.isCancelled).reduce(0) { $0 + $1.savedAmount }
    }

    func monthlyEquivalent(of sub: Subscription) -> Decimal {
        sub.price * sub.billingCycle.monthlyEquivalent
    }

    func savingsRecords(from subscriptions: [Subscription]) -> [SavingsRecord] {
        subscriptions.filter(\.isCancelled).compactMap { sub in
            guard let cancelledDate = sub.cancelledDate else { return nil }
            return SavingsRecord(
                subscriptionName: sub.name,
                monthlyAmount: monthlyEquivalent(of: sub),
                cancelledDate: cancelledDate,
                category: sub.category.rawValue
            )
        }
    }

    func markAsCancelled(_ sub: Subscription, context: ModelContext) {
        sub.isCancelled = true
        sub.cancelledDate = Date()
        sub.isActive = false
        sub.savedAmount = monthlyEquivalent(of: sub)
        try? context.save()
    }
}
