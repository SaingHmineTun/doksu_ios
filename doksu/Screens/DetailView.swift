import SwiftUI

struct DetailView: View {
    @EnvironmentObject private var player: DokSuPlayer
    @Environment(\.dismiss) private var dismiss
    @State private var dragOffset: CGFloat = 0

    let song: Song

    private var currentSong: Song {
        DokSuData.song(player.currentPage)
    }

    var body: some View {
        VStack(spacing: 0) {
            toggleStrip
                .frame(height: 60) // ADD THIS: Forces the bar to stay exactly 44pt tall
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 6)

            ScrollViewReader { proxy in
                ScrollView {
                    Text(DokSuData.lyrics(for: player.currentPage, showingChords: player.showChord))
                        .lineSpacing(5)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .id(player.currentPage)
                }
                .gesture(
                    DragGesture()
                        .onChanged { dragOffset = $0.translation.width }
                        .onEnded { value in
                            if value.translation.width > 120 {
                                player.previous()
                            } else if value.translation.width < -120 {
                                player.next()
                            }
                            dragOffset = 0
                        }
                )
                .onChange(of: player.currentPage) { _, page in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        proxy.scrollTo(page, anchor: .top)
                    }
                }
            }

            VStack(spacing: 10) {
                if !player.readMode {
                    playerProgress
                }

                transportControls
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .padding(.bottom, 12)
            .background(.regularMaterial)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(currentSong.numberedTitle)
                    .font(.custom(DokSuFonts.ajKunheing, size: 24))
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
            }
        }
        .onAppear {
            player.open(song: song)
        }
    }

    private var toggleStrip: some View {
        HStack(spacing: 0) {
            compactToggle(title: "ၼႄၶွတ်ႇတိင်ႇ", isOn: $player.showChord)

            Rectangle()
                .fill(Color(.separator))
                .frame(width: 1)

            compactToggle(title: "ၽုၺ်ႇသဵင်ၵႂၢမ်း", isOn: Binding(
                get: { !player.readMode },
                set: { player.togglePlayMode($0) }
            ))
        }
        .padding(.vertical, 6)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    private func compactToggle(title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 8) {
            Text(title)
                .font(.custom(DokSuFonts.ajKunheing, size: 20))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .frame(maxWidth: .infinity, alignment: .leading)

            Toggle(title, isOn: isOn)
                .labelsHidden()
                .scaleEffect(0.82)
                .frame(width: 44)
        }
        .padding(.leading, 12)
        .padding(.trailing, 8)
        .frame(maxWidth: .infinity)
    }

    private var playerProgress: some View {
        HStack(spacing: 8) {
            Text(player.currentTime.formattedTime)
                .font(.caption.monospacedDigit())
            Slider(value: Binding(
                get: { player.currentTime },
                set: { player.seek(to: $0) }
            ), in: 0...max(player.duration, 1))
            Text(player.duration.formattedTime)
                .font(.caption.monospacedDigit())
        }
    }

    private var transportControls: some View {
        HStack {
            CircleButton(systemName: "backward.fill", label: "Previous") {
                player.previous()
            }

            if !player.readMode {
                CircleButton(systemName: player.isPlaying ? "pause.fill" : "play.fill", label: "Play or pause") {
                    player.isPlaying ? player.pause() : player.play()
                }

                CircleButton(systemName: "stop.fill", label: "Stop") {
                    player.stopAudio()
                    dismiss()
                }
            }

            CircleButton(systemName: "forward.fill", label: "Next") {
                player.next()
            }
        }
        .frame(maxWidth: .infinity)
    }
}
