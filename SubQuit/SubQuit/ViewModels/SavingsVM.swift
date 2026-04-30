import SwiftData
import SwiftUI

@Observable
final class SavingsVM {
    var totalSaved: Decimal = 0
    var monthlySpent: Decimal = 0
    var yearlySpent: Decimal = 0
    var savingsRecords: [SavingsRecord] = []

    private let calculator = SavingsCalculator()

    func calculate(subscriptions: [Subscription]) {
        totalSaved = calculator.totalSaved(subscriptions: subscriptions)
        monthlySpent = calculator.totalMonthlySpent(subscriptions: subscriptions)
        yearlySpent = calculator.totalYearlySpent(subscriptions: subscriptions)
        savingsRecords = calculator.savingsRecords(from: subscriptions)
    }

    func markAsCancelled(_ sub: Subscription, context: ModelContext) {
        calculator.markAsCancelled(sub, context: context)
    }
}
