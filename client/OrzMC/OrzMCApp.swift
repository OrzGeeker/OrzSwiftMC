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
                    .frame(width: LauncherModel.shared.windowSize.width, height: LauncherModel.shared.windowSize.height)
#elseif os(iOS)
                ContentView().environmentObject(Model.shared)
#endif
            }
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
#if os(macOS)
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
#elseif os(iOS)
#endif
    }
}
