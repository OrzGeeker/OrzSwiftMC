//
//  ServerView.swift
//  OrzMC
//
//  Created by joker on 2023/4/2.
//

import SwiftUI
import Game
import JokerKits

struct ServerView: View {
    
    @EnvironmentObject private var appModel: LauncherModel
        
    var body: some View {
        VStack {
            HStack {
                Group {
                    ForEach(appModel.externalLinks, id: \.title) { externalLink in
                        Link(destination: externalLink.link) {
                            ImageTitleText(
                                title: externalLink.title,
                                imageSystemName: externalLink.systemImageName)
                        }
                    }
                }
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text("三方插件:")
                    .font(.title3)
                Spacer()
                LauncherUIButton(
                    title: "下载",
                    imageSystemName: "arrow.down.circle.fill") {
                        Task {
                            if !appModel.isPluginsDownloading, let outpuFileDirURL = URL(string: "\(NSHomeDirectory())/Downloads/plugins") {
                                appModel.isPluginsDownloading = true
                                try await Downloader.download(PluginInfo.downloadItemInfos(of: outpuFileDirURL))
                                await Shell.runCommand(with: ["open", "\(outpuFileDirURL.path)"])
                                appModel.isPluginsDownloading = false
                            }
                        }
                    }
                    .disabled(appModel.isPluginsDownloading)
                if(appModel.isPluginsDownloading){
                    ProgressView()
                        .scaleEffect(0.5)
                }
            }
            .padding(.top, 10)
            
            List(PluginInfo.allPlugins(), id: \.name) { plugInfo in
                if let site = plugInfo.site, let destURL = URL(string: site) {
                    Link(destination: destURL) {
                        HStack {
                            Text(plugInfo.name)
                                .font(.subheadline)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
            .listStyle(SidebarListStyle())
            Spacer()
        }
        .padding()
    }
}

struct ServerView_Previews: PreviewProvider {
    static var previews: some View {
        ServerView()
            .frame(width: 400, height: 200)
            .environmentObject(LauncherModel.mockModel)
    }
}
