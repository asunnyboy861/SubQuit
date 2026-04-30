import SwiftUI

struct CancelGuideListView: View {
    @State private var vm = CancelGuideVM()
    @State private var selectedGuide: CancelGuide?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    categoryFilter
                    guidesList
                }
                .padding()
            }
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
            .navigationTitle("Cancel Guides")
            .searchable(text: $vm.searchText, prompt: "Search services")
            .onChange(of: vm.searchText) { _, _ in vm.loadGuides() }
            .onChange(of: vm.selectedCategory) { _, _ in vm.loadGuides() }
            .onAppear { vm.loadGuides() }
            .navigationDestination(item: $selectedGuide) { guide in
                CancelGuideDetailView(guide: guide)
            }
        }
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                CategoryPill(title: "All", isSelected: vm.selectedCategory == nil) {
                    vm.selectedCategory = nil
                }
                ForEach(vm.categories(), id: \.self) { category in
                    CategoryPill(title: category, isSelected: vm.selectedCategory == category) {
                        vm.selectedCategory = category
                    }
                }
            }
        }
    }

    private var guidesList: some View {
        LazyVStack(spacing: 12) {
            if vm.guides.isEmpty {
                ContentUnavailableView(
                    "No Guides Found",
                    systemImage: "magnifyingglass",
                    description: Text("Try a different search term")
                )
            } else {
                ForEach(vm.guides) { guide in
                    CancelGuideRow(guide: guide)
                        .onTapGesture { selectedGuide = guide }
                }
            }
        }
    }
}

struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.secondary.opacity(0.15))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}

struct CancelGuideRow: View {
    let guide: CancelGuide

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(guide.serviceName)
                    .font(.subheadline)
                    .bold()
                HStack(spacing: 8) {
                    DifficultyBadge(difficulty: guide.difficulty)
                    Text(guide.estimatedTime)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
