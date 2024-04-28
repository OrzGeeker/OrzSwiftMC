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
#if os(macOS)
        MacOSScene()
#elseif os(iOS)
        WindowGroup {
            ContentView()
                .environment(Model())
        }
#endif
    }
}
