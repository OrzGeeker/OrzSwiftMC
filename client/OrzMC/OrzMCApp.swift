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
    @StateObject var appModel = model
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            //            ContentView()
            //                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            LauncherUI()
                .alert(appModel.alertMessage ?? "", isPresented: $appModel.showAlert) {
                    Button(appModel.alertActionTip) {
                        
                    }
                }
                .environmentObject(appModel)
        }
    }
}
