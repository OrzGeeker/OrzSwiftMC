//
//  OrzMCApp.swift
//  OrzMC
//
//  Created by joker on 2022/10/18.
//

import SwiftUI
#if canImport(OrzAppUpdater)
import OrzAppUpdater
#endif

@main
struct OrzMCApp: App {
#if canImport(OrzAppUpdater)
    let updaterController = OrzAppUpdaterController()
#endif
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
