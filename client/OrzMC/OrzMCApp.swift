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
    @StateObject var appModel = model
#endif
    @Environment(\.scenePhase) var scenePhase
    static var appFirstLaunched = true
    var body: some Scene {
        WindowGroup {
#if os(macOS)
            LauncherUI()
                .alert(appModel.alertMessage ?? "", isPresented: $appModel.showAlert) {
                    Button(appModel.alertActionTip) {
                        
                    }
                }
                .environmentObject(appModel)
                .environment(\.managedObjectContext, appModel.persistenceController.container.viewContext)
#elseif os(iOS)
            ContentView()
#endif
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active && Self.appFirstLaunched {
#if os(macOS)
                appModel.loadDbClientInfoItem()
#endif
                Self.appFirstLaunched = false
            }
        }
    }
}
