import SwiftData
import SwiftUI

@Observable
final class SubscriptionListVM {
    var searchText = ""
    var selectedCategory: SubscriptionCategory?

    var filteredSubscriptions: [Subscription] = []

    func fetchSubscriptions(context: ModelContext) {
        var descriptor = FetchDescriptor<Subscription>(sortBy: [SortDescriptor(\.nextBillingDate)])
        if let category = selectedCategory {
            descriptor.predicate = #Predicate { $0.category == category }
        }
        if let results = try? context.fetch(descriptor) {
            if searchText.isEmpty {
                filteredSubscriptions = results
            } else {
                filteredSubscriptions = results.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }

    func activeSubscriptions() -> [Subscription] {
        filteredSubscriptions.filter(\.isActive)
    }

    func cancelledSubscriptions() -> [Subscription] {
        filteredSubscriptions.filter(\.isCancelled)
    }

    func deleteSubscription(_ sub: Subscription, context: ModelContext) {
        context.delete(sub)
        try? context.save()
    }
}
