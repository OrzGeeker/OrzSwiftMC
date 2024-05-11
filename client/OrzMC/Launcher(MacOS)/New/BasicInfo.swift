//
//  BasicInfo.swift
//  OrzMC
//
//  Created by joker on 2024/4/28.
//

import SwiftUI
import Mojang
import Game
import JokerKits

struct FilePathEntry: View {
    let name: String
    let path: String
    var body: some View {
        HStack {
            Text(name)
                .bold()
                .foregroundStyle(Color.accentColor)
                .padding([.trailing], 5)
            
            Text(path)
                .foregroundStyle(path.isExist() ? Color.primary : Color.red)
            
            if path.isExist() {
                Spacer()
                Button(action: {
                    _ = try? Shell.runCommand(with: ["open", "\(path)"])
                }, label: {
                    Image(systemName: path.isDirPath() ? "folder" : "doc.plaintext")
                })
                .buttonStyle(.plain)
            }
        }
    }
}
struct BasicInfo: View {
    
    @Environment(GameModel.self) private var model
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        Form {
            if let serverDirPath, serverDirPath.isExist() {
                Section("Server") {
                    FilePathEntry(
                        name: "Game",
                        path: serverDirPath
                    )
                    if let serverPluginDirPath {
                        FilePathEntry(
                            name: "Plugins",
                            path: serverPluginDirPath
                        )
                    }
                }
            }
            if let clientDirPath, clientDirPath.isExist() {
                Section("Client") {
                    FilePathEntry(
                        name: "Game",
                        path: clientDirPath
                    )
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle(model.detailTitle)
        .onReceive(timer) { _ in
            model.checkRunningServer()
        }
        .toolbar {
            if model.isShowKillAllServerButton {
                ToolbarItem {
                    Button {
                        model.stopAllRunningServer()
                    } label: {
                        Text("Stop All Servers")
                            .foregroundStyle(Color.accentColor)
                            .padding(4)
                            .bold()
                    }
                }
            }
        }
    }
}

extension BasicInfo {
    
    var serverDirPath: String? {
        guard let selectedVersion = model.selectedVersion
        else {
            return nil
        }
        return GameDir.server(version: selectedVersion.id, type: GameType.paper.rawValue).dirPath
    }
    
    var serverPluginDirPath: String? {
        guard let selectedVersion = model.selectedVersion
        else {
            return nil
        }
        return GameDir.serverPlugin(version: selectedVersion.id, type: GameType.paper.rawValue).dirPath
    }
    
    var clientDirPath: String? {
        guard let selectedVersion = model.selectedVersion
        else {
            return nil
        }
        return GameDir.client(version: selectedVersion.id, type: GameType.vanilla.rawValue).dirPath
    }
}


#Preview {
    BasicInfo().environment(GameModel())
}
