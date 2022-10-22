//
//  OrzMCApp.swift
//  OrzMC
//
//  Created by joker on 2022/10/18.
//

import SwiftUI

@main
struct OrzMCApp: App {
    @StateObject var appModel = model
    @Environment(\.scenePhase) var scenePhase
    static var appFirstLaunched = true
    var body: some Scene {
        WindowGroup {
            LauncherUI()
                .alert(appModel.alertMessage ?? "", isPresented: $appModel.showAlert) {
                    Button(appModel.alertActionTip) {
                        
                    }
                }
                .environmentObject(appModel)
                .environment(\.managedObjectContext, appModel.persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active && Self.appFirstLaunched {
                appModel.loadDbClientInfoItem()
                Self.appFirstLaunched = false
            }
        }
    }
}
