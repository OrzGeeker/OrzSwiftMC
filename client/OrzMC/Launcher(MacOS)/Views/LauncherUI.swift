//
//  LauncherUI.swift
//  OrzMC
//
//  Created by joker on 2022/10/19.
//

import SwiftUI

struct LauncherUI: View {
    
    @EnvironmentObject private var appModel: LauncherModel
    
    @Environment(\.scenePhase) var scenePhase
    
    static private var appFirstLaunched = true
    
    @State private var path = NavigationPath()
    
    var body: some View {
        
        NavigationStack(path: $path) {
            MainView()
        }
        .alert(appModel.alertMessage ?? "", isPresented: $appModel.showAlert) {
            Button(appModel.alertActionTip) {
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active && Self.appFirstLaunched {
                appModel.loadDbClientInfoItem()
                Self.appFirstLaunched = false
            }
        }
        .frame(width: appModel.windowSize.width, height: appModel.windowSize.height)
    }
}

struct LauncherUI_Previews: PreviewProvider {
    static var previews: some View {
        LauncherUI()
            .environmentObject(LauncherModel())
    }
}

