import StoreKit
import SwiftUI

@Observable
final class AppleSubDetector {
    var appleSubscriptions: [AppleSubscription] = []
    var isLoading = false

    struct AppleSubscription: Identifiable {
        let id: String
        let productName: String
        let price: Decimal
        let renewalDate: Date?
    }

    func fetchSubscriptions() async {
        isLoading = true
        defer { isLoading = false }

        var subs: [AppleSubscription] = []

        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.expirationDate ?? .distantFuture > Date() {
                    let product = try? await Product.products(for: [transaction.productID]).first
                    let sub = AppleSubscription(
                        id: transaction.productID,
                        productName: product?.displayName ?? transaction.productID,
                        price: product?.price ?? 0,
                        renewalDate: transaction.expirationDate
                    )
                    subs.append(sub)
                }
            }
        }

        appleSubscriptions = subs
    }
}
