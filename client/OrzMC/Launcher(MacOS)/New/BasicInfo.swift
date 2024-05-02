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
struct BasicInfo: View {

    @Environment(GameModel.self) private var model

    var body: some View {
        
        Form {
            
            if let selectedVersion = model.selectedVersion {
                Section("Server") {
                    FilePathEntry(
                        name: "Game",
                        path: GameDir.server(
                            version: selectedVersion.id,
                            type: GameType.paper.rawValue
                        )
                        .dirPath
                    )
                    FilePathEntry(
                        name: "Plugins",
                        path: GameDir.serverPlugin(
                            version: selectedVersion.id,
                            type: GameType.paper.rawValue
                        )
                        .dirPath
                    )
                }
                Section("Client") {
                    FilePathEntry(
                        name: "Game",
                        path: GameDir.client(
                            version: selectedVersion.id,
                            type: GameType.vanilla.rawValue
                        )
                        .dirPath
                    )
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle(model.detailTitle)
        .task {
            model.checkRunningServer()
        }
        .toolbar {
            if model.isShowKillAllServerButton {
                ToolbarItem {
                    Button {
                        model.killAllRunningServer()
                    } label: {
                        Text("Kill Running Servers")
                            .foregroundStyle(Color.accentColor)
                            .padding(4)
                            .bold()
                    }
                }
            }
        }
    }
}


#Preview {
    BasicInfo().environment(GameModel())
}
