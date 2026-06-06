//
//  doksuApp.swift
//  doksu
//
//  Created by Sai Mao on 6/6/2569 BE.
//

import SwiftUI

@main
struct doksuApp: App {
    @StateObject private var player = DokSuPlayer()

    init() {
        DokSuFonts.register()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(player)
        }
    }
}
