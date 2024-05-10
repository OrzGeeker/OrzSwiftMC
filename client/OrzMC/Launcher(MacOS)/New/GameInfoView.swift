//
//  GameInfoView.swift
//  OrzMC
//
//  Created by joker on 2024/4/28.
//

import SwiftUI
import SwiftUIX

struct GameInfoView: View {
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            BasicInfo()
        }
        .navigationDestination(for: URL.self) { url in
            Web(url: url)
        }
        .toolbar {
            
            ToolbarItem {
                Button(action: {
                    path.append(URL(string: "https://minecraft.jokerhub.cn")!)
                }, label: {
                    Image(systemName: "house")
                        .padding(4)
                })
                .buttonStyle(.borderedProminent)
            }
            
            ToolbarItem {
                Button(action: {
                    path.append(URL(string: "https://papermc.io/")!)
                }, label: {
                    Image(systemName: "paperplane")
                        .padding(4)
                })
                .buttonStyle(.borderedProminent)
            }
            
            ToolbarItem {
                Button(action: {
                    path.append(URL(string: "https://hangar.papermc.io/")!)
                }, label: {
                    Image(systemName: "powerplug")
                        .padding(4)
                })
                .buttonStyle(.borderedProminent)
            }
            
            ToolbarItem {
                Button {
                    path.append(URL(string: "https://aternos.org/")!)
                } label: {
                    Image(systemName: "server.rack")
                }
                .buttonStyle(.borderedProminent)
                
            }
            
            ToolbarItem {
                
//                FeedBackButton(email: "824219521@qq.com")
            }
        }
    }
}

