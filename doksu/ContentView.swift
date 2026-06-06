import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var player: DokSuPlayer
    @State private var navigationPath: [Song] = []

    var body: some View {
        NavigationStack(path: $navigationPath) {
            List(DokSuData.songs) { song in
                Button {
                    player.open(song: song)
                    navigationPath.append(song)
                } label: {
                    SongRow(song: song)
                }
                .buttonStyle(.plain)
                .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 12))
            }
            .listStyle(.insetGrouped)
            .safeAreaInset(edge: .bottom) {
                if player.isPlaying {
                    miniPlayerLink
                }
            }
            .navigationDestination(for: Song.self) { song in
                DetailView(song: song)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("ၽဵင်းၵႂၢမ်းတုၵ်းသူး")
                        .font(.custom(DokSuFonts.ajKunheing, size: 26))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .accessibilityLabel("About")
                }
            }
        }
        .tint(.dokSuPrimary)
    }

    private var miniPlayerLink: some View {
        NavigationLink(value: DokSuData.song(player.currentPage)) {
            HStack(spacing: 10) {
                Image(systemName: "music.note")
                    .font(.headline)

                Text(DokSuData.song(player.currentPage).numberedTitle)
                    .font(.custom(DokSuFonts.ajKunheing, size: 22))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(player.currentTime.formattedTime)
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(.regularMaterial, in: Capsule())
            .padding(.horizontal, 14)
            .padding(.bottom, 8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
        .environmentObject(DokSuPlayer())
}
