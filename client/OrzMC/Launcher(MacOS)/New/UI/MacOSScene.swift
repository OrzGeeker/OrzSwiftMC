//
//  MacOSScene.swift
//  OrzMC
//
//  Created by joker on 2024/4/28.
//

import SwiftUI

struct MacOSScene: Scene {
    var body: some Scene {
        Window("Home", id: "macos") {
            LauncherUI()
                .frame(minWidth: Constants.minWidth, minHeight: Constants.minHeight)
                .environment(GameModel())
        }
        .windowResizability(.contentSize)
    }
}
