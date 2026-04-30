import SwiftUI

@Observable
final class CancelGuideVM {
    var searchText = ""
    var selectedCategory: String?
    var guides: [CancelGuide] = []

    private let repository = CancelGuideRepository.shared

    func loadGuides() {
        if let category = selectedCategory {
            guides = repository.guides(byCategory: category)
        } else {
            guides = repository.searchGuides(query: searchText)
        }
    }

    func categories() -> [String] {
        repository.categories()
    }

    func guide(for serviceName: String) -> CancelGuide? {
        repository.guide(for: serviceName)
    }
}
