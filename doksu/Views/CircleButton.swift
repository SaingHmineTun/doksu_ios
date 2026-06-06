import SwiftUI

struct CircleButton: View {
    let systemName: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title3.weight(.semibold))
                .frame(width: 48, height: 48)
                .background(Circle().fill(Color(.secondarySystemGroupedBackground)))
        }
        .frame(maxWidth: .infinity)
        .accessibilityLabel(label)
    }
}
