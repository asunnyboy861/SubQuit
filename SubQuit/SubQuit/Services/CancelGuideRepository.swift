import Foundation

@Observable
final class CancelGuideRepository {
    static let shared = CancelGuideRepository()

    private var guides: [CancelGuide] = []

    private init() {
        loadGuides()
    }

    private func loadGuides() {
        guard let url = Bundle.main.url(forResource: "cancel_guides_index", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            guides = try JSONDecoder().decode([CancelGuide].self, from: data)
        } catch {
            print("Failed to load cancel guides: \(error)")
        }
    }

    func guide(for serviceName: String) -> CancelGuide? {
        guides.first { $0.serviceName.lowercased() == serviceName.lowercased() }
    }

    func allGuides() -> [CancelGuide] {
        guides.sorted { $0.serviceName < $1.serviceName }
    }

    func guides(byCategory category: String) -> [CancelGuide] {
        guides.filter { $0.category == category }
    }

    func searchGuides(query: String) -> [CancelGuide] {
        guard !query.isEmpty else { return allGuides() }
        return guides.filter { $0.serviceName.localizedCaseInsensitiveContains(query) }
    }

    func hardToCancelGuides() -> [CancelGuide] {
        guides.filter { $0.difficulty == .hard || $0.difficulty == .veryHard }
    }

    func categories() -> [String] {
        Array(Set(guides.map(\.category))).sorted()
    }
}
