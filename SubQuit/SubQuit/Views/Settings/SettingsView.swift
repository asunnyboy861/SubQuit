import SwiftUI
import StoreKit

struct SettingsView: View {
    @AppStorage("useCloudKit") private var useCloudKit = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var purchaseManager = PurchaseManager()
    @State private var showPaywall = false

    private let supportURL = "https://asunnyboy861.github.io/SubQuit/support.html"
    private let privacyURL = "https://asunnyboy861.github.io/SubQuit/privacy.html"
    private let termsURL = "https://asunnyboy861.github.io/SubQuit/terms.html"

    var body: some View {
        NavigationStack {
            Form {
                premiumSection
                syncSection
                notificationsSection
                aboutSection
                legalSection
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showPaywall) {
                PaywallView(purchaseManager: purchaseManager)
            }
            .task {
                await purchaseManager.loadProducts()
                await purchaseManager.restorePurchases()
            }
        }
    }

    private var premiumSection: some View {
        Section {
            if purchaseManager.isPremium {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundStyle(.yellow)
                    Text("SubQuit Premium")
                        .bold()
                    Spacer()
                    Text("Active")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            } else {
                Button {
                    showPaywall = true
                } label: {
                    HStack {
                        Image(systemName: "crown")
                            .foregroundStyle(.yellow)
                        Text("Upgrade to Premium")
                            .bold()
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private var syncSection: some View {
        Section("Sync") {
            Toggle("iCloud Sync", isOn: $useCloudKit)
            Text("Sync your subscriptions across all devices")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var notificationsSection: some View {
        Section("Notifications") {
            NavigationLink {
                Text("Notification settings coming soon")
            } label: {
                Label("Billing Reminders", systemImage: "bell.badge")
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            NavigationLink {
                ContactSupportView()
            } label: {
                Label("Contact Support", systemImage: "envelope")
            }
        }
    }

    private var legalSection: some View {
        Section("Legal") {
            Link("Support", destination: URL(string: supportURL)!)
            Link("Privacy Policy", destination: URL(string: privacyURL)!)
            Link("Terms of Use", destination: URL(string: termsURL)!)
            Button {
                Task { await purchaseManager.restorePurchases() }
            } label: {
                Label("Restore Purchases", systemImage: "arrow.uturn.down")
            }
        }
    }
}

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    let purchaseManager: PurchaseManager
    @State private var selectedProduct: Product?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.yellow)

                    Text("SubQuit Premium")
                        .font(.title)
                        .bold()

                    Text("Unlock all cancellation guides, savings dashboard, and iCloud sync")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    VStack(spacing: 12) {
                        ForEach(purchaseManager.products, id: \.id) { product in
                            ProductRow(product: product, isSelected: selectedProduct?.id == product.id) {
                                selectedProduct = product
                            }
                        }
                    }
                    .padding()

                    Button {
                        if let product = selectedProduct {
                            Task {
                                let success = await purchaseManager.purchase(product)
                                if success { dismiss() }
                            }
                        }
                    } label: {
                        Text("Subscribe")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedProduct == nil ? Color.gray : Color.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(selectedProduct == nil)

                    Text("Auto-renews. Cancel anytime in Settings > Subscriptions.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
            .onAppear {
                if let first = purchaseManager.products.first {
                    selectedProduct = first
                }
            }
        }
    }
}

struct ProductRow: View {
    let product: Product
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.displayName)
                        .font(.subheadline)
                        .bold()
                    Text(product.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(product.displayPrice)
                    .font(.subheadline)
                    .bold()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? .blue : .secondary)
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.secondary.opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
}
