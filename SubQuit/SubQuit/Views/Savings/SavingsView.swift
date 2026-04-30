import SwiftUI
import SwiftData
import Charts

struct SavingsView: View {
    @Query private var subscriptions: [Subscription]
    @State private var savingsVM = SavingsVM()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    totalSavedCard
                    spendingBreakdown
                    savingsTimeline
                    cancelledList
                }
                .padding()
            }
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
            .navigationTitle("Savings")
            .onAppear {
                savingsVM.calculate(subscriptions: subscriptions)
            }
            .onChange(of: subscriptions) { _, _ in
                savingsVM.calculate(subscriptions: subscriptions)
            }
        }
    }

    private var totalSavedCard: some View {
        VStack(spacing: 12) {
            Text("Total Saved")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text(String(format: "$%.2f", NSDecimalNumber(decimal: savingsVM.totalSaved).doubleValue))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(.green)

            HStack(spacing: 24) {
                VStack {
                    Text(String(format: "$%.2f", NSDecimalNumber(decimal: savingsVM.monthlySpent).doubleValue))
                        .font(.title3)
                        .bold()
                    Text("Monthly")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                VStack {
                    Text(String(format: "$%.2f", NSDecimalNumber(decimal: savingsVM.yearlySpent).doubleValue))
                        .font(.title3)
                        .bold()
                    Text("Yearly")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var spendingBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Spending by Category")
                .font(.headline)

            let activeSubs = subscriptions.filter(\.isActive)
            if activeSubs.isEmpty {
                Text("No active subscriptions")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                let categoryData = Dictionary(grouping: activeSubs, by: \.category)
                    .map { (category, subs) in
                        CategorySpending(
                            category: category.rawValue,
                            amount: subs.reduce(Decimal(0)) { $0 + ($1.price * $1.billingCycle.monthlyEquivalent) }
                        )
                    }
                    .sorted { $0.amount > $1.amount }

                Chart(categoryData) { item in
                    SectorMark(
                        angle: .value("Amount", NSDecimalNumber(decimal: item.amount).doubleValue),
                        innerRadius: .ratio(0.5),
                        angularInset: 2
                    )
                    .foregroundStyle(by: .value("Category", item.category))
                }
                .frame(height: 200)

                ForEach(categoryData) { item in
                    HStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 8, height: 8)
                        Text(item.category)
                            .font(.subheadline)
                        Spacer()
                        Text(String(format: "$%.2f/mo", NSDecimalNumber(decimal: item.amount).doubleValue))
                            .font(.subheadline)
                            .bold()
                    }
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var savingsTimeline: some View {
        Group {
            if !savingsVM.savingsRecords.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Savings Over Time")
                        .font(.headline)

                    Chart(savingsVM.savingsRecords) { record in
                        BarMark(
                            x: .value("Date", record.cancelledDate, unit: .month),
                            y: .value("Saved", NSDecimalNumber(decimal: record.totalSaved).doubleValue)
                        )
                        .foregroundStyle(.green.gradient)
                    }
                    .frame(height: 180)
                }
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }

    private var cancelledList: some View {
        Group {
            let cancelled = subscriptions.filter(\.isCancelled)
            if !cancelled.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Cancelled Subscriptions")
                        .font(.headline)

                    ForEach(cancelled) { sub in
                        HStack {
                            Image(systemName: sub.category.icon)
                                .foregroundStyle(.green)
                            VStack(alignment: .leading) {
                                Text(sub.name)
                                    .font(.subheadline)
                                if let date = sub.cancelledDate {
                                    Text("Cancelled \(date.formatted(date: .abbreviated, time: .omitted))")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                            Text(String(format: "$%.2f saved", NSDecimalNumber(decimal: sub.savedAmount).doubleValue))
                                .font(.caption)
                                .foregroundStyle(.green)
                                .bold()
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding()
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

struct CategorySpending: Identifiable {
    let id = UUID()
    let category: String
    let amount: Decimal
}
