import Foundation

struct CancelGuide: Codable, Identifiable, Hashable {
    static func == (lhs: CancelGuide, rhs: CancelGuide) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    let id: String
    let serviceName: String
    let category: String
    let difficulty: CancelDifficulty
    let estimatedTime: String
    let cancelMethods: [CancelMethod]
    let steps: [CancelStep]
    let tips: [String]
    let warnings: [String]
    let alternativeActions: [String]
    let lastVerified: String
    let iconAssetName: String
}

enum CancelDifficulty: String, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case veryHard = "Very Hard"

    var colorHex: String {
        switch self {
        case .easy: "#34C759"
        case .medium: "#FF9500"
        case .hard: "#FF3B30"
        case .veryHard: "#8E0038"
        }
    }
}

enum CancelMethod: String, Codable {
    case website = "Website"
    case app = "In-App"
    case phone = "Phone Call"
    case inPerson = "In Person"
    case email = "Email"
    case appleSettings = "Apple Settings"
}

struct CancelStep: Codable, Identifiable {
    let id: UUID
    let order: Int
    let instruction: String
    let detail: String
    let screenshotName: String?
    let actionType: StepAction
    let targetElement: String

    init(order: Int, instruction: String, detail: String,
         screenshotName: String? = nil,
         actionType: StepAction, targetElement: String) {
        self.id = UUID()
        self.order = order
        self.instruction = instruction
        self.detail = detail
        self.screenshotName = screenshotName
        self.actionType = actionType
        self.targetElement = targetElement
    }
}

enum StepAction: String, Codable {
    case tap = "Tap"
    case scroll = "Scroll"
    case type = "Type"
    case navigate = "Navigate"
    case confirm = "Confirm"
    case wait = "Wait"
}
