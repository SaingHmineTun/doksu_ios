import SwiftUI

struct SongRow: View {
    let song: Song

    var body: some View {
        HStack(spacing: 12) {
            BundleImage(name: "song_icon")
                .frame(width: 38, height: 38)

            Text(song.numberedTitle)
                .font(.custom(DokSuFonts.ajKunheing, size: 28))
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .minimumScaleFactor(0.75)
        }
    }
}
