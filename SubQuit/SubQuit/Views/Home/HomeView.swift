import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var vm = SubscriptionListVM()
    @State private var savingsVM = SavingsVM()
    @State private var showAddSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    spendingSummary
                    activeSubscriptionsList
                    if !vm.cancelledSubscriptions().isEmpty {
                        cancelledSection
                    }
                }
                .padding()
            }
            .navigationTitle("SubQuit")
            .searchable(text: $vm.searchText, prompt: "Search subscriptions")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddSubscriptionView()
            }
            .onChange(of: vm.searchText) { _, _ in
                vm.fetchSubscriptions(context: modelContext)
            }
            .onAppear {
                vm.fetchSubscriptions(context: modelContext)
                savingsVM.calculate(subscriptions: vm.filteredSubscriptions)
            }
            .onChange(of: vm.filteredSubscriptions) { _, newSubs in
                savingsVM.calculate(subscriptions: newSubs)
            }
        }
    }

    private var spendingSummary: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Monthly Spending")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(String(format: "$%.2f", NSDecimalNumber(decimal: savingsVM.monthlySpent).doubleValue))
                        .font(.title)
                        .bold()
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Yearly Total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(String(format: "$%.2f", NSDecimalNumber(decimal: savingsVM.yearlySpent).doubleValue))
                        .font(.title3)
                        .bold()
                }
            }

            if savingsVM.totalSaved > 0 {
                Divider()
                HStack {
                    Image(systemName: "piggybank.fill")
                        .foregroundStyle(.green)
                    Text(String(format: "You've saved $%.2f", NSDecimalNumber(decimal: savingsVM.totalSaved).doubleValue))
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(.green)
                    Spacer()
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var activeSubscriptionsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Active Subscriptions")
                .font(.headline)

            if vm.activeSubscriptions().isEmpty {
                ContentUnavailableView(
                    "No Subscriptions",
                    systemImage: "tray",
                    description: Text("Tap + to add your first subscription")
                )
            } else {
                ForEach(vm.activeSubscriptions()) { sub in
                    SubscriptionCard(subscription: sub)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                vm.deleteSubscription(sub, context: modelContext)
                                vm.fetchSubscriptions(context: modelContext)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
    }

    private var cancelledSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cancelled")
                .font(.headline)
                .foregroundStyle(.secondary)

            ForEach(vm.cancelledSubscriptions()) { sub in
                SubscriptionCard(subscription: sub)
                    .opacity(0.6)
            }
        }
    }
}
