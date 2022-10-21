//
//  OrzMCApp.swift
//  OrzMC
//
//  Created by joker on 2022/10/18.
//

import SwiftUI

@main
struct OrzMCApp: App {
    let persistenceController = PersistenceController.shared

    let divide = 5.0
    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            LauncherUI().fixedSize(horizontal: false, vertical: true)
        }
    }
}
