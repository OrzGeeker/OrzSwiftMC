//
//  OrzMCApp.swift
//  OrzMC
//
//  Created by joker on 2022/10/18.
//

import SwiftUI

@main
struct OrzMCApp: App {
    
#if os(macOS)
    @State var model = LauncherModel()
#endif
    
#if os(iOS)
    @StateObject var model = Model()
#endif
    
    var body: some Scene {
        WindowGroup {
            VStack {
#if os(macOS)
                LauncherUI()
#elseif os(iOS)
                ContentView()
#endif
            }
            .environment(model)
        }
#if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
#elseif os(iOS)
#endif
    }
}
