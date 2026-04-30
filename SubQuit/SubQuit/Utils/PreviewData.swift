import Foundation
import SwiftData

enum PreviewData {
    @MainActor
    static func insertSampleData(context: ModelContext) {
        let existing = try? context.fetch(FetchDescriptor<Subscription>())
        if let existing, !existing.isEmpty { return }

        let netflix = Subscription(
            name: "Netflix",
            category: .streaming,
            price: 15.49,
            currency: "USD",
            billingCycle: .monthly,
            nextBillingDate: Calendar.current.date(byAdding: .day, value: 12, to: Date())!,
            startDate: Calendar.current.date(byAdding: .month, value: -6, to: Date())!,
            icon: "tv.fill",
            colorHex: "#E50914"
        )

        let spotify = Subscription(
            name: "Spotify",
            category: .music,
            price: 10.99,
            currency: "USD",
            billingCycle: .monthly,
            nextBillingDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
            startDate: Calendar.current.date(byAdding: .month, value: -12, to: Date())!,
            icon: "music.note",
            colorHex: "#1DB954"
        )

        let adobe = Subscription(
            name: "Adobe CC",
            category: .software,
            price: 54.99,
            currency: "USD",
            billingCycle: .monthly,
            nextBillingDate: Calendar.current.date(byAdding: .day, value: 20, to: Date())!,
            startDate: Calendar.current.date(byAdding: .month, value: -3, to: Date())!,
            icon: "paintbrush.fill",
            colorHex: "#FF0000"
        )

        let iCloud = Subscription(
            name: "iCloud+",
            category: .cloud,
            price: 2.99,
            currency: "USD",
            billingCycle: .monthly,
            nextBillingDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            startDate: Calendar.current.date(byAdding: .month, value: -24, to: Date())!,
            icon: "cloud.fill",
            colorHex: "#007AFF"
        )

        let gym = Subscription(
            name: "Gym Membership",
            category: .fitness,
            price: 49.99,
            currency: "USD",
            billingCycle: .monthly,
            nextBillingDate: Calendar.current.date(byAdding: .day, value: 8, to: Date())!,
            startDate: Calendar.current.date(byAdding: .month, value: -9, to: Date())!,
            icon: "figure.run",
            colorHex: "#FF9500"
        )

        let hulu = Subscription(
            name: "Hulu",
            category: .streaming,
            price: 17.99,
            currency: "USD",
            billingCycle: .monthly,
            nextBillingDate: Calendar.current.date(byAdding: .day, value: 15, to: Date())!,
            startDate: Calendar.current.date(byAdding: .month, value: -4, to: Date())!,
            icon: "play.tv.fill",
            colorHex: "#1CE783"
        )

        let cancelledDisney = Subscription(
            name: "Disney+",
            category: .streaming,
            price: 13.99,
            currency: "USD",
            billingCycle: .monthly,
            nextBillingDate: Calendar.current.date(byAdding: .day, value: -5, to: Date())!,
            startDate: Calendar.current.date(byAdding: .month, value: -8, to: Date())!,
            icon: "star.fill",
            colorHex: "#113CCF"
        )
        cancelledDisney.isCancelled = true
        cancelledDisney.cancelledDate = Calendar.current.date(byAdding: .day, value: -5, to: Date())
        cancelledDisney.savedAmount = 13.99

        let cancelledAmazon = Subscription(
            name: "Amazon Prime",
            category: .other,
            price: 14.99,
            currency: "USD",
            billingCycle: .monthly,
            nextBillingDate: Calendar.current.date(byAdding: .day, value: -10, to: Date())!,
            startDate: Calendar.current.date(byAdding: .month, value: -6, to: Date())!,
            icon: "cart.fill",
            colorHex: "#FF9900"
        )
        cancelledAmazon.isCancelled = true
        cancelledAmazon.cancelledDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())
        cancelledAmazon.savedAmount = 14.99

        for sub in [netflix, spotify, adobe, iCloud, gym, hulu, cancelledDisney, cancelledAmazon] {
            context.insert(sub)
        }

        try? context.save()
    }
}
