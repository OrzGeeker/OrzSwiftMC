//
//  MainView.swift
//  OrzMC
//
//  Created by joker on 2023/3/26.
//

import SwiftUI

enum Page {
    case settings
}

struct MainView: View {
    
    @EnvironmentObject private var appModel: LauncherModel
    
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
                NavigationLink(value: Page.settings) {
                    LauncherUIButton(title: "设置",imageSystemName: "gearshape")
                        .buttonStyle(.borderless)
                        .disabled(true)
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
            .navigationDestination(for: Page.self) { page in
                switch page {
                case .settings:
                    SettingsView()
                }
            }
    }
}

struct MainView_Previews: PreviewProvider {
    
    static let mockModel = LauncherModel.mockModel
    
    static var previews: some View {
        MainView()
            .environmentObject(mockModel)
            .previewLayout(.fixed(width: mockModel.windowSize.width, height: mockModel.windowSize.height))
    }
}
