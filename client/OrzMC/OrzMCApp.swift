//
//  OrzMCApp.swift
//  OrzMC
//
//  Created by joker on 2022/10/18.
//

import SwiftUI
import OrzAppUpdater

@main
struct OrzMCApp: App {
    let updaterController = OrzAppUpdaterController(startingUpdater: false)
    var body: some Scene {
#if os(macOS)
        MacOSScene()
            .addCheckUpdatesCommand(updaterController: updaterController)
#elseif os(iOS)
        WindowGroup {
            ContentView()
                .environment(Model())
        }
#endif
    }
}
