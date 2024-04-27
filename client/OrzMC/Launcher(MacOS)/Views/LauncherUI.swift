//
//  LauncherUI.swift
//  OrzMC
//
//  Created by joker on 2022/10/19.
//

import SwiftUI

struct LauncherUI: View {

    @Environment(LauncherModel.self) private var model

    @Environment(\.scenePhase) var scenePhase
    
    static private var appFirstLaunched = true
    
    @State private var path = NavigationPath()
    
    @State private var gameModel = GameModel()
    
    var body: some View {
        
        NavigationSplitView {
            
            GameVersionList()
                .environment(gameModel)
                
        } detail: {
            Text("Detail")
        }
        

//        NavigationStack(path: $path) {
//            MainView()
//        }
//        .alert(appModel.alertMessage ?? "", isPresented: $appModel.showLoading) {
//            Button(appModel.alertActionTip) {
//            }
//        }
//        .onChange(of: scenePhase) { oldValue, newValue in
//            if newValue == .active && Self.appFirstLaunched {
//                Self.appFirstLaunched = false
//            }
//        }
//        .frame(width: appModel.windowSize.width, height: appModel.windowSize.height)
    }
}

#Preview {
    LauncherUI()
        .environment(LauncherModel())
}
