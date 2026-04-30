import StoreKit
import SwiftUI

@Observable
final class PurchaseManager {
    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []
    var isLoading = false

    var isPremium: Bool {
        purchasedProductIDs.contains("com.zzoutuo.SubQuit.monthly") ||
        purchasedProductIDs.contains("com.zzoutuo.SubQuit.yearly") ||
        purchasedProductIDs.contains("com.zzoutuo.SubQuit.lifetime")
    }

    var isFreeTier: Bool { !isPremium }

    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let storeProducts = try await Product.products(for: [
                "com.zzoutuo.SubQuit.monthly",
                "com.zzoutuo.SubQuit.yearly",
                "com.zzoutuo.SubQuit.lifetime"
            ])
            products = storeProducts.sorted { $0.price < $1.price }
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    func purchase(_ product: Product) async -> Bool {
        do {
            let result = try await product.purchase()
            if case .success(let verification) = result {
                if case .verified(let transaction) = verification {
                    purchasedProductIDs.insert(transaction.productID)
                    await transaction.finish()
                    return true
                }
            }
        } catch {
            print("Purchase failed: \(error)")
        }
        return false
    }

    func restorePurchases() async {
        do {
            for await result in Transaction.currentEntitlements {
                if case .verified(let transaction) = result {
                    purchasedProductIDs.insert(transaction.productID)
                }
            }
        } catch {
            print("Restore failed: \(error)")
        }
    }

    func listenForTransactions() async {
        for await result in Transaction.updates {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
                await transaction.finish()
            }
        }
    }
}
