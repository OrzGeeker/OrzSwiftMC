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
            ToolbarItemGroup {
                ForEach([
                    ("https://minecraft.jokerhub.cn", "house"),
                    ("https://papermc.io/", "paperplane"),
                    ("https://hangar.papermc.io/", "powerplug"),
                    ("https://aternos.org/", "server.rack")
                ], id: \.0) { info in
                    Button(action: {
                        path.append(URL(string: info.0)!)
                    }, label: {
                        Image(systemName: info.1)
                            .padding(4)
                    })
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}
