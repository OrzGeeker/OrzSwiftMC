//
//  LauncherUI.swift
//  OrzMC
//
//  Created by joker on 2022/10/19.
//

import SwiftUI

struct LauncherUI: View {

    @Environment(LauncherModel.self) private var appModel

    @Environment(\.scenePhase) var scenePhase
    
    static private var appFirstLaunched = true
    
    @State private var path = NavigationPath()
    
    var body: some View {
        @Bindable var appModel = appModel
        NavigationStack(path: $path) {
            MainView()
        }
        .alert(appModel.alertMessage ?? "", isPresented: $appModel.showLoading) {
            Button(appModel.alertActionTip) {
            }
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .active && Self.appFirstLaunched {
                Self.appFirstLaunched = false
            }
        }
        .frame(width: appModel.windowSize.width, height: appModel.windowSize.height)
    }
}

#Preview {
    LauncherUI()
        .environment(LauncherModel())
}
