import CoreText
import Foundation

enum DokSuFonts {
    static let ajKunheing = "AJKunheing05-Regular"
    static let namteng = "NamTeng2020"

    static func register() {
        ["aj_kunheing", "namteng"].forEach { name in
            guard let url = Bundle.main.url(forResource: name, withExtension: "ttf") else { return }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }
}
