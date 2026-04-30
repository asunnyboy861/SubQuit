import SwiftUI

struct CancelGuideDetailView: View {
    let guide: CancelGuide
    @State private var currentStepIndex = 0
    @State private var completedSteps: Set<Int> = []

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                guideHeader
                progressIndicator
                currentStepCard
                stepNavigation
                tipsSection
                warningsSection
                alternativeActionsSection
            }
            .padding()
        }
        .frame(maxWidth: 720)
        .frame(maxWidth: .infinity)
        .navigationTitle(guide.serviceName)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var guideHeader: some View {
        VStack(spacing: 12) {
            DifficultyBadge(difficulty: guide.difficulty)
            Text(guide.estimatedTime)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                ForEach(guide.cancelMethods, id: \.self) { method in
                    Text(method.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var progressIndicator: some View {
        ProgressView(value: Double(completedSteps.count), total: Double(guide.steps.count))
            .padding(.horizontal)
    }

    private var currentStepCard: some View {
        let step = guide.steps[currentStepIndex]
        let isCompleted = completedSteps.contains(step.order)

        return VStack(spacing: 16) {
            HStack {
                Text("Step \(step.order) of \(guide.steps.count)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
            }

            Text(step.instruction)
                .font(.headline)

            Text(step.detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 6) {
                Image(systemName: stepIcon(for: step.actionType))
                Text(step.actionType.rawValue)
                    .font(.caption)
                Text("-")
                Text(step.targetElement)
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle(.blue)
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var stepNavigation: some View {
        HStack {
            Button {
                withAnimation { currentStepIndex = max(0, currentStepIndex - 1) }
            } label: {
                Label("Previous", systemImage: "chevron.left")
            }
            .disabled(currentStepIndex == 0)

            Spacer()

            if completedSteps.count == guide.steps.count {
                Label("All Done!", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .bold()
            } else {
                Button {
                    completedSteps.insert(guide.steps[currentStepIndex].order)
                    if currentStepIndex < guide.steps.count - 1 {
                        withAnimation { currentStepIndex += 1 }
                    }
                } label: {
                    Label("Complete Step", systemImage: "checkmark")
                }
                .buttonStyle(.borderedProminent)
            }

            Spacer()

            Button {
                withAnimation { currentStepIndex = min(guide.steps.count - 1, currentStepIndex + 1) }
            } label: {
                Label("Next", systemImage: "chevron.right")
            }
            .disabled(currentStepIndex == guide.steps.count - 1)
        }
        .padding(.horizontal)
    }

    private var tipsSection: some View {
        Group {
            if !guide.tips.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Tips", systemImage: "lightbulb.fill")
                        .font(.headline)
                        .foregroundStyle(.yellow)
                    ForEach(guide.tips, id: \.self) { tip in
                        HStack(alignment: .top) {
                            Text("\u{2022}")
                            Text(tip)
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .background(Color.yellow.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var warningsSection: some View {
        Group {
            if !guide.warnings.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Warnings", systemImage: "exclamationmark.triangle.fill")
                        .font(.headline)
                        .foregroundStyle(.red)
                    ForEach(guide.warnings, id: \.self) { warning in
                        HStack(alignment: .top) {
                            Text("\u{2022}")
                            Text(warning)
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var alternativeActionsSection: some View {
        Group {
            if !guide.alternativeActions.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Alternatives", systemImage: "arrow.triangle.branch")
                        .font(.headline)
                        .foregroundStyle(.blue)
                    ForEach(guide.alternativeActions, id: \.self) { action in
                        HStack(alignment: .top) {
                            Text("\u{2022}")
                            Text(action)
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private func stepIcon(for action: StepAction) -> String {
        switch action {
        case .tap: "hand.tap"
        case .scroll: "scroll"
        case .type: "keyboard"
        case .navigate: "arrow.right"
        case .confirm: "checkmark"
        case .wait: "clock"
        }
    }
}
