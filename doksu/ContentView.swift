import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var player: DokSuPlayer
    @State private var navigationPath: [Song] = []

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                LazyVStack(spacing: 12) { // Increased gap between rows
                    ForEach(DokSuData.songs) { song in
                        Button {
                            player.open(song: song)
                            navigationPath.append(song)
                        } label: {
                            SongRow(song: song)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14) // Increased internal tap target / breathing room
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color(.secondarySystemGroupedBackground))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                // Ensures content isn't covered by miniplayer when scrolled to the very bottom
                .padding(.bottom, player.isPlaying ? 85 : 24)
            }
            .background(Color(.systemGroupedBackground))
            .safeAreaInset(edge: .bottom) {
                if player.isPlaying {
                    miniPlayerLink
                        .transition(.move(edge: .bottom).combined(with: .opacity))
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
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Image(systemName: "info.circle.fill") // Using filled icon for better visual balance
                            .font(.body)
                    }
                    .accessibilityLabel("About")
                }
            }
        }
        .tint(.dokSuPrimary)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: player.isPlaying)
    }

    private var miniPlayerLink: some View {
        NavigationLink(value: DokSuData.song(player.currentPage)) {
            HStack(spacing: 14) { // Slightly increased element spacing
                ZStack {
                    Circle()
                        .fill(Color.dokSuPrimary.opacity(0.15))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "music.note")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.primary)
                }

                Text(DokSuData.song(player.currentPage).numberedTitle)
                    .font(.custom(DokSuFonts.ajKunheing, size: 22))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(player.currentTime.formattedTime)
                    .font(.subheadline.monospacedDigit()) // Slightly cleaner font scale
                    .foregroundStyle(.secondary)

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.leading, 8) // Accommodates the new decorative icon circle balance
            .padding(.trailing, 16)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial) // Gives a premium translucent look floating over scroll content
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4) // Makes it pop out from the list context
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .buttonStyle(.plain)
    }
}
