import Foundation
import SwiftUI

enum DokSuData {
    static let songs: [Song] = [
        Song(id: 1, title: "ၵႃႈပၼ်ႇၵွင်ႊ"),
        Song(id: 2, title: "ၵႂၢမ်းၶွပ်ႈၸႂ်"),
        Song(id: 3, title: "ၵႂၢမ်းၸူမ်းပီႈၼွင့် (1)"),
        Song(id: 4, title: "ၵႂၢမ်းၸူမ်းပီႈၼွင့် (2)"),
        Song(id: 5, title: "ၶိူဝ်းသိူဝ်လၢႆး"),
        Song(id: 6, title: "ၶတ်းၸႂ်ႁႂ်ႈမႂ်ႇသုင်"),
        Song(id: 7, title: "ၶိုၼ်းဢွမ်ႇၸႂ်ႁပ့်ပီႊမႂ်ႇ"),
        Song(id: 8, title: "ၶွပ်ႈၶိုၼ်းပီႊမႂ်ႇ"),
        Song(id: 9, title: "သဵင်သၢႆၸႂ်ပီႊမႂ်ႇ"),
        Song(id: 10, title: "သဵင်ပၢႆးမွၼ်းတုၵ်းသူး"),
        Song(id: 11, title: "တႆးႁူပ့်ထူပ်းၵၼ်"),
        Song(id: 12, title: "တုၵ်းသူးမၢႆ (1)"),
        Song(id: 13, title: "တုၵ်းသူးမၢႆ (2)"),
        Song(id: 14, title: "တုၵ်းသူးမၢႆ (3)"),
        Song(id: 15, title: "တုၵ်းသူးသၢႆၸႂ်ၸိူဝ့်"),
        Song(id: 16, title: "တၢင်းႁၢင်ႊလီၽၵ်းတူၸႂ်"),
        Song(id: 17, title: "ထုင်းၾိင်ႈယဵၼ်ႇငႄႈသၢႆၸႂ်တႆး"),
        Song(id: 18, title: "ပီႊမႂ်ႇတႆး (1)"),
        Song(id: 19, title: "ပီႊမႂ်ႇတႆး (2)"),
        Song(id: 20, title: "ပီႊမႂ်ႇတႆး (3)"),
        Song(id: 21, title: "ပွႆးလိူၼ်ၸဵင်ပီႊမႂ်ႇတႆး"),
        Song(id: 22, title: "ပဵၼ်ၸႂ်လဵဝ်ၵၼ်ႁဝ်း"),
        Song(id: 23, title: "ၽွင်းၶၢဝ်းၵတ်းပီႊမႂ်ႇ"),
        Song(id: 24, title: "မႂ်ႇသုင်"),
        Song(id: 25, title: "ယႃႇႁႂ်ႈဢဵၼ်ႁႅင်းႁၢႆ"),
        Song(id: 26, title: "ယွၼ်းသူးထိုင်ၸဝ်ႈႁိူၼ်း"),
        Song(id: 27, title: "ယွၼ်းသူးပၼ်ၸဝ်ႈႁိူၼ်း"),
        Song(id: 28, title: "ယွၼ်းသူးႁႂ်ႈမႂ်ႇသုင်"),
        Song(id: 29, title: "ယွၼ်းတုၵ်းသူး"),
        Song(id: 30, title: "ႁူႉလႄႈၸၢႆးယိင်းတႆး"),
        Song(id: 31, title: "ႁဝ်းၼမ်ႁဝ်းလီ ပႂ်ႉႁပ့်ပီႊမႂ်ႇ"),
        Song(id: 32, title: "ႁဝ်းၽွမ့်ၵၼ်"),
        Song(id: 33, title: "ႁဝ်းဝႅင်းၵႃႈပၼ်ႇၵွင်ႊ"),
        Song(id: 34, title: "ႁႂ်ႈယူႇလီမီးငိုၼ်း"),
        Song(id: 35, title: "ႁူမ်ႈႁႅင်းပီႊမႂ်ႇတႆး"),
        Song(id: 36, title: "ဢွၼ်ၵၼ်ၶတ်းၸႂ်")
    ]

    static func song(_ id: Int) -> Song {
        songs.first { $0.id == id } ?? songs[0]
    }

    static func lyrics(for page: Int, showingChords: Bool) -> AttributedString {
        let rawLyrics = readLyrics(page: page, showingChords: showingChords)
        var processedLyrics = rawLyrics

        if !showingChords {
            // Remove all chord tokens when chords are disabled
            if let regex = try? NSRegularExpression(pattern: #"\b([A-GO](#|b|m|bm|7)?)\b"#) {
                let range = NSRange(processedLyrics.startIndex..., in: processedLyrics)
                processedLyrics = regex.stringByReplacingMatches(in: processedLyrics, options: [], range: range, withTemplate: "")
            }
            // Clean up extra spaces that might be left behind
            processedLyrics = processedLyrics.replacingOccurrences(of: "[ \\t]+", with: " ", options: .regularExpression)
            processedLyrics = processedLyrics.replacingOccurrences(of: " \\n", with: "\n", options: .regularExpression)
            processedLyrics = processedLyrics.replacingOccurrences(of: "\n ", with: "\n", options: .regularExpression)
        }

        var attributed = AttributedString(processedLyrics)
        attributed.font = .custom(DokSuFonts.namteng, size: 20)
        attributed.foregroundColor = .primary

        if showingChords {
            highlight(pattern: #"\b([A-GO](#|b|m|bm|7)?\s*)\b"#, in: &attributed, color: .dokSuError, font: .system(size: 20, weight: .bold))
        }

        for line in processedLyrics.split(separator: "\n", omittingEmptySubsequences: false) where line.contains("-") {
            guard let range = attributed.range(of: String(line)) else { continue }
            attributed[range].font = .custom(DokSuFonts.ajKunheing, size: 30)
            attributed[range].foregroundColor = .dokSuError
        }

        return attributed
    }

    private static func readLyrics(page: Int, showingChords: Bool) -> String {
        guard let url = Bundle.main.url(forResource: "tmk\(page)", withExtension: "txt"),
              let content = try? String(contentsOf: url, encoding: .utf8) else {
            return ""
        }

        let lines = content.components(separatedBy: .newlines).dropFirst()
        var visibleLines: [String] = []
        for line in lines {
            if !showingChords {
                if isChordLine(line) {
                    continue
                }
                let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.lowercased().hasPrefix("key") || trimmed.hasPrefix("Key") || trimmed.contains("Key -") || trimmed.lowercased().hasPrefix("beat") || trimmed.hasPrefix("Beat") || trimmed.contains("Beat -") {
                    continue
                }
                // Also catch lines that are just key/beat info
                if trimmed.range(of: #"^Key\s*-.*$"#, options: .regularExpression) != nil ||
                   trimmed.range(of: #"^Beat\s*-.*$"#, options: .regularExpression) != nil {
                    continue
                }
            }
            visibleLines.append(line)
        }
        return visibleLines.joined(separator: "\n") + "\n\n"
    }

    private static func isChordLine(_ line: String) -> Bool {
        let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return false
        }
        guard let regex = try? NSRegularExpression(pattern: #"^(\s*([A-GO](#|b|m|bm|7)?\s*)\s*)+$"#) else {
            return line.range(of: #"(\s*([A-GO](#|b|m|bm|7)?\s*)\s*)+"#, options: .regularExpression) == line.startIndex..<line.endIndex
        }
        let range = NSRange(line.startIndex..., in: line)
        if let match = regex.firstMatch(in: line, options: [], range: range) {
            return match.range.location == 0 && match.range.length == line.utf16.count
        }
        return false
    }

    private static func highlight(pattern: String, in attributed: inout AttributedString, color: Color, font: Font) {
        let text = String(attributed.characters)
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return }
        let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))

        for match in matches {
            guard let stringRange = Range(match.range, in: text),
                  let range = Range(stringRange, in: attributed) else { continue }
            attributed[range].foregroundColor = color
            attributed[range].font = font
        }
    }
}
