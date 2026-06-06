import SwiftUI
import UIKit

struct BundleImage: View {
    let name: String

    var body: some View {
        Group {
            if let url = Bundle.main.url(forResource: name, withExtension: "png"),
               let uiImage = UIImage(contentsOfFile: url.path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "music.note")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.dokSuPrimary)
            }
        }
    }
}
