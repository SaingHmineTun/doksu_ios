import SwiftUI

struct AboutRow: View {
    var imageName: String?
    var systemName: String?
    let label: String
    let value: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                if let imageName {
                    BundleImage(name: imageName)
                        .frame(width: 28, height: 28)
                } else if let systemName {
                    Image(systemName: systemName)
                        .font(.title3)
                        .frame(width: 28, height: 28)
                        .foregroundStyle(Color.dokSuPrimary)
                }

                Text(label)
                    .font(.custom(DokSuFonts.ajKunheing, size: 20))

                Text(value)
                    .font(.custom(DokSuFonts.ajKunheing, size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .foregroundStyle(.primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, minHeight: 70, alignment: .leading)
        }
        .buttonStyle(.plain)
    }
}
