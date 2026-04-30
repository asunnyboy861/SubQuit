import Foundation

struct SavingsRecord: Identifiable {
    let id: UUID
    let subscriptionName: String
    let monthlyAmount: Decimal
    let cancelledDate: Date
    let category: String

    var totalSaved: Decimal {
        let months = Calendar.current.dateComponents([.month], from: cancelledDate, to: Date()).month ?? 0
        return monthlyAmount * Decimal(max(months, 0))
    }

    init(subscriptionName: String, monthlyAmount: Decimal, cancelledDate: Date, category: String) {
        self.id = UUID()
        self.subscriptionName = subscriptionName
        self.monthlyAmount = monthlyAmount
        self.cancelledDate = cancelledDate
        self.category = category
    }
}
