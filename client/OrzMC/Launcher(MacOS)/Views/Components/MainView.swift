//
//  MainView.swift
//  OrzMC
//
//  Created by joker on 2023/3/26.
//

import SwiftUI

enum Page {
    case server
    case settings
}

struct MainView: View {
    
    @EnvironmentObject private var appModel: LauncherModel
    
    @FocusState private var focusState: Bool
    
    var body: some View {
        LauncherBackgroundView()
            .overlay(alignment: .topLeading) {
                LauncherUserLoginArea(username: $appModel.username) {
                    Task {
                        try await appModel.launch()
                        focusState = false
                    }
                }
                .focused($focusState)
                .disabled(appModel.showLoading)
            }
            .overlay(alignment: .topTrailing) {
                HStack {
                    NavigationLink(value: Page.server) {
                        ImageTitleText(
                            title: "服务器",
                            imageSystemName: "externaldrive.badge.icloud")
                    }
                    NavigationLink(value: Page.settings) {
                        ImageTitleText(
                            title: "设置",
                            imageSystemName: "gearshape")
                    }
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
            .overlay(alignment: .center) {
                if appModel.showLoading {
                    ProgressView()
                }
            }
            .task {
                await appModel.fetchGameVersions()
            }
            .navigationDestination(for: Page.self) { page in
                switch page {
                case .server:
                    ServerView()
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
