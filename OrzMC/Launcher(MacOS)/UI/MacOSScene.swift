//
//  MacOSScene.swift
//  OrzMC
//
//  Created by joker on 2024/4/28.
//

import SwiftUI

struct MacOSScene: Scene {
    
    @State private var model = GameModel()
    
    var body: some Scene {
        Window("Home", id: "macos") {
            LauncherUI()
                .frame(minWidth: Constants.minWidth, minHeight: Constants.minHeight)
                .environment(model)
        }
        .windowResizability(.contentSize)
        
        Settings {
            SettingsView()
                .environment(model.settingsModel)
        }
    }
}
