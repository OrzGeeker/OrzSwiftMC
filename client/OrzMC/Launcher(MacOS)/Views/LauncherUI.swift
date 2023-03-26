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
    
    static var appFirstLaunched = true
    
    var body: some View {
        LauncherBackgroundView()
            .overlay(alignment: .topLeading) {
                LauncherUserLoginArea(username: $appModel.username) {
                    Task {
                        try await appModel.launch()
                    }
                }
            }
            .overlay(alignment: .topTrailing) {
                LauncherUIButton(title:"设置", imageSystemName: "gearshape") {
                    // 跳转设置页
                }
                .padding()
            }
            .overlay(alignment: .bottomLeading) {
                LauncherGameVersionSelector(
                    versions: appModel.versions,
                    selectedVersion: $appModel.selectedVersion,
                    profiles: appModel.profileItems,
                    selectedProfile: $appModel.selectedProfileItem,
                    gameVersionDownloadProgress: appModel.launcherProgress) {
                        Task {
                            await appModel.fetchGameVersions()
                        }
                    }
            }
            .overlay(alignment: .bottomTrailing, content: {
                
            })
            .overlay(alignment: .center) {
                if appModel.loadingItemCount > 0 {
                    ProgressView()
                }
            }
            .task {
                await appModel.fetchGameVersions()
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
    }
}

struct LauncherUI_Previews: PreviewProvider {
    static var previews: some View {
        LauncherUI()
            .environmentObject(LauncherModel.mockModel)
    }
}

