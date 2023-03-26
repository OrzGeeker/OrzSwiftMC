//
//  LauncherGameVersionSelector.swift
//  OrzMC
//
//  Created by joker on 2022/10/21.
//

import SwiftUI

struct LauncherGameVersionSelector: View {
    
    let versions: [String]
    
    @Binding var selectedVersion: String
    
    let profiles: [String]
    
    @Binding var selectedProfile: String
    
    let gameVersionDownloadProgress: Double
    
    var refreshVersionsAction: LauncherUIButtonAction?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading){
                    if !versions.isEmpty {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Picker(selection: $selectedVersion, label: Text("游戏版本").bold()) {
                                        ForEach(versions, id: \.self) {
                                            Text($0).tag($0)
                                        }
                                    }
                                    LauncherUIButton(imageSystemName: "arrow.clockwise", action: refreshVersionsAction)
                                }
                                if profiles.count > 1 {
                                    Picker(selection: $selectedProfile, label: Text("启动方式").bold()) {
                                        ForEach(profiles, id: \.self) {
                                            Text($0).tag($0)
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: 200)
                        }
                    }
                }
            }
            
            if gameVersionDownloadProgress.isZero {
                // Do nothing
            }
            else if gameVersionDownloadProgress > 0, gameVersionDownloadProgress < 1 {
                Divider().frame(height: 10)
                LauncherProgressView(title: "游戏下载进度", progress: gameVersionDownloadProgress)
            } else {
                Text("资源已下载完成，游戏启动中，请稍等......")
            }
        }
        .padding()
    }
}

struct GameVersionPickerView_Previews: PreviewProvider {
    
    static let gameVersions = [
        "1.19.4",
        "1.19.3",
        "1.19.2",
        "1.19.1",
        "1.19",
        "1.18.2",
    ]
    
    static let gameProfiles = [
        "normal",
        "optfine"
    ]
    
    static var previews: some View {
        
        LauncherGameVersionSelector(
            versions: gameVersions,
            selectedVersion: .constant(gameVersions.first!),
            profiles: [],
            selectedProfile: .constant(""),
            gameVersionDownloadProgress: 0)
        .previewDisplayName("版本选择")
        
        LauncherGameVersionSelector(
            versions: gameVersions,
            selectedVersion: .constant(gameVersions.first!),
            profiles: [],
            selectedProfile: .constant(""),
            gameVersionDownloadProgress: 0.8)
        .previewDisplayName("版本选择+下载进度")
        
        LauncherGameVersionSelector(
            versions: gameVersions,
            selectedVersion: .constant(gameVersions.first!),
            profiles: [],
            selectedProfile: .constant(""),
            gameVersionDownloadProgress: 1)
        .previewDisplayName("版本选择+下载完成")
        
        LauncherGameVersionSelector(
            versions: gameVersions,
            selectedVersion: .constant(gameVersions.first!),
            profiles: gameProfiles,
            selectedProfile: .constant(gameProfiles.first!),
            gameVersionDownloadProgress: 0.5)
        .previewDisplayName("版本+启动方式+下载进度")

    }
}
