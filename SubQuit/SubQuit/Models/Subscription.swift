import SwiftData
import Foundation

@Model
final class Subscription {
    @Attribute(.unique) var id: UUID
    var name: String
    var category: SubscriptionCategory
    var price: Decimal
    var currency: String
    var billingCycle: BillingCycle
    var nextBillingDate: Date
    var startDate: Date
    var isActive: Bool
    var notes: String
    var icon: String
    var colorHex: String
    var isCancelled: Bool
    var cancelledDate: Date?
    var savedAmount: Decimal

    init(
        name: String,
        category: SubscriptionCategory = .streaming,
        price: Decimal,
        currency: String = "USD",
        billingCycle: BillingCycle = .monthly,
        nextBillingDate: Date,
        startDate: Date = .now,
        icon: String = "app.fill",
        colorHex: String = "#007AFF"
    ) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.price = price
        self.currency = currency
        self.billingCycle = billingCycle
        self.nextBillingDate = nextBillingDate
        self.startDate = startDate
        self.isActive = true
        self.notes = ""
        self.icon = icon
        self.colorHex = colorHex
        self.isCancelled = false
        self.cancelledDate = nil
        self.savedAmount = 0
    }
}

enum SubscriptionCategory: String, Codable, CaseIterable {
    case streaming = "Streaming"
    case music = "Music"
    case fitness = "Fitness"
    case software = "Software"
    case gaming = "Gaming"
    case news = "News"
    case food = "Food & Meal Kits"
    case cloud = "Cloud Storage"
    case vpn = "VPN & Security"
    case education = "Education"
    case other = "Other"

    var icon: String {
        switch self {
        case .streaming: "tv.fill"
        case .music: "music.note"
        case .fitness: "figure.run"
        case .software: "desktopcomputer"
        case .gaming: "gamecontroller.fill"
        case .news: "newspaper.fill"
        case .food: "takeoutbag.and.cup.and.straw.fill"
        case .cloud: "cloud.fill"
        case .vpn: "lock.shield.fill"
        case .education: "book.fill"
        case .other: "app.fill"
        }
    }
}

enum BillingCycle: String, Codable, CaseIterable {
    case weekly = "Weekly"
    case monthly = "Monthly"
    case quarterly = "Quarterly"
    case yearly = "Yearly"

    var monthsPerCycle: Int {
        switch self {
        case .weekly: return 0
        case .monthly: return 1
        case .quarterly: return 3
        case .yearly: return 12
        }
    }

    var monthlyEquivalent: Decimal {
        switch self {
        case .weekly: return 4.33
        case .monthly: return 1
        case .quarterly: return 0.333
        case .yearly: return 0.0833
        }
    }
}
