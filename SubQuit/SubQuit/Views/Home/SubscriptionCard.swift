import SwiftUI

struct SubscriptionCard: View {
    let subscription: Subscription

    private var monthlyEquiv: Decimal {
        subscription.price * subscription.billingCycle.monthlyEquivalent
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: subscription.category.icon)
                .font(.title2)
                .foregroundStyle(Color(hex: subscription.colorHex) ?? .blue)
                .frame(width: 40, height: 40)
                .background(Color(hex: subscription.colorHex)?.opacity(0.15) ?? Color.blue.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(subscription.name)
                    .font(.subheadline)
                    .bold()
                Text("\(subscription.billingCycle.rawValue) - Next: \(subscription.nextBillingDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "$%.2f", NSDecimalNumber(decimal: subscription.price).doubleValue))
                    .font(.subheadline)
                    .bold()
                Text(String(format: "$%.2f/mo", NSDecimalNumber(decimal: monthlyEquiv).doubleValue))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        guard hexSanitized.count == 6 else { return nil }

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        self.init(
            red: Double((rgb & 0xFF0000) >> 16) / 255.0,
            green: Double((rgb & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgb & 0x0000FF) / 255.0
        )
    }
}
