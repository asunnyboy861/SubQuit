import SwiftUI

struct DifficultyBadge: View {
    let difficulty: CancelDifficulty

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(Color(hex: difficulty.colorHex) ?? .gray)
                .frame(width: 8, height: 8)
            Text(difficulty.rawValue)
                .font(.caption2)
                .bold()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(hex: difficulty.colorHex)?.opacity(0.15) ?? Color.gray.opacity(0.15))
        .clipShape(Capsule())
    }
}
