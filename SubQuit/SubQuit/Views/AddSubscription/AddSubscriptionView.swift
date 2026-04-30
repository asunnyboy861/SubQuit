import SwiftUI
import SwiftData

struct AddSubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name = ""
    @State private var category: SubscriptionCategory = .streaming
    @State private var price: Decimal = 9.99
    @State private var currency = "USD"
    @State private var billingCycle: BillingCycle = .monthly
    @State private var nextBillingDate = Date()
    @State private var startDate = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section("Subscription Details") {
                    TextField("Service Name", text: $name)
                    Picker("Category", selection: $category) {
                        ForEach(SubscriptionCategory.allCases, id: \.self) { cat in
                            Label(cat.rawValue, systemImage: cat.icon).tag(cat)
                        }
                    }
                }

                Section("Pricing") {
                    HStack {
                        Text("$")
                        TextField("Price", value: $price, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    Picker("Billing Cycle", selection: $billingCycle) {
                        ForEach(BillingCycle.allCases, id: \.self) { cycle in
                            Text(cycle.rawValue).tag(cycle)
                        }
                    }
                }

                Section("Dates") {
                    DatePicker("Next Billing Date", selection: $nextBillingDate, displayedComponents: .date)
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                }
            }
            .navigationTitle("Add Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addSubscription()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }

    private func addSubscription() {
        let sub = Subscription(
            name: name,
            category: category,
            price: price,
            currency: currency,
            billingCycle: billingCycle,
            nextBillingDate: nextBillingDate,
            startDate: startDate,
            icon: category.icon,
            colorHex: "#007AFF"
        )
        modelContext.insert(sub)
        try? modelContext.save()
        dismiss()
    }
}
