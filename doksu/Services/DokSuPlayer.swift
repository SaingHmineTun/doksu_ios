import AVFoundation
import Combine
import SwiftUI

@MainActor
final class DokSuPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @AppStorage("read_mode") var readMode = false
    @AppStorage("show_chord") var showChord = false

    @Published var currentPage = 1
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0

    private var audioPlayer: AVAudioPlayer?
    private var loadedPage: Int?
    private var timer: Timer?

    func open(song: Song) {
        if readMode {
            currentPage = song.id
            stopAudio()
        } else {
            play(page: song.id)
        }
    }

    func togglePlayMode(_ enabled: Bool) {
        readMode = !enabled
        if enabled {
            play(page: currentPage)
        } else {
            stopAudio()
        }
    }

    func play(page: Int? = nil) {
        let target = page ?? currentPage
        if target != loadedPage || audioPlayer == nil {
            loadAudio(page: target)
        }

        audioPlayer?.play()
        isPlaying = audioPlayer?.isPlaying ?? false
        startTimer()
    }

    func pause() {
        audioPlayer?.pause()
        isPlaying = false
        stopTimer()
    }

    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        audioPlayer = nil
        loadedPage = nil
        currentTime = 0
        duration = 0
        isPlaying = false
        stopTimer()
    }

    func next() {
        let page = currentPage == DokSuData.songs.count ? 1 : currentPage + 1
        move(to: page)
    }

    func previous() {
        let page = currentPage == 1 ? DokSuData.songs.count : currentPage - 1
        move(to: page)
    }

    func seek(to time: TimeInterval) {
        audioPlayer?.currentTime = min(max(0, time), duration)
        currentTime = audioPlayer?.currentTime ?? time
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        next()
    }

    private func move(to page: Int) {
        if readMode {
            currentPage = page
            stopAudio()
        } else {
            play(page: page)
        }
    }

    private func loadAudio(page: Int) {
        guard let url = Bundle.main.url(forResource: "tmk\(page)", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            loadedPage = page
            currentPage = page
            duration = audioPlayer?.duration ?? 0
            currentTime = 0
        } catch {
            stopAudio()
        }
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                self.currentTime = self.audioPlayer?.currentTime ?? 0
                self.duration = self.audioPlayer?.duration ?? self.duration
                self.isPlaying = self.audioPlayer?.isPlaying ?? false
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
