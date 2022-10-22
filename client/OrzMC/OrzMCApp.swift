//
//  OrzMCApp.swift
//  OrzMC
//
//  Created by joker on 2022/10/18.
//

import SwiftUI

@main
struct OrzMCApp: App {
    let divide = 5.0
    let appModel = LauncherModel()
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            LauncherUI()
                .environmentObject(appModel)
        }
    }
}
