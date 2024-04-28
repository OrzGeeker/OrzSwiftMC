//
//  OrzMCApp.swift
//  OrzMC
//
//  Created by joker on 2022/10/18.
//

import SwiftUI

@main
struct OrzMCApp: App {

    var body: some Scene {

        WindowGroup {
#if os(macOS)
            LauncherUI()
                .environment(GameModel())
#elseif os(iOS)
            ContentView()
                .environment(Model())
#endif
        }
    }
}
