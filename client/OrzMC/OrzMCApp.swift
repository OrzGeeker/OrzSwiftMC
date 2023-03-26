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
            VStack {
#if os(macOS)
                LauncherUI().environmentObject(LauncherModel.shared)
#elseif os(iOS)
                ContentView().environmentObject(Model.shared)
#endif
            }
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
#if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
#elseif os(iOS)
#endif
    }
}
