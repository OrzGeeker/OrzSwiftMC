//
//  GameInfoView.swift
//  OrzMC
//
//  Created by joker on 2024/4/28.
//

import SwiftUI
import SwiftUIX

struct LinkInfo: Identifiable, Hashable {
    var id: String { url }

    let url: String
    let icon: String

    enum LinkType {
        case home
        case papermc
        case gameExt
        case testServer
        case onlineServer
        case other
    }
    let type: LinkType
}
let items: [LinkInfo] = [
    .init(url: "https://minecraft.jokerhub.cn", icon: "house", type: .home),
    .init(url: "https://papermc.io/", icon: "paperplane", type: .papermc),
    .init(url: "https://hangar.papermc.io/", icon: "powerplug", type: .gameExt),
    .init(url: "https://aternos.org/server/", icon: "testtube.2", type: .testServer),
    .init(url: "https://exaroton.com/server", icon: "server.rack", type: .onlineServer),
]

struct GameInfoView: View {
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            BasicInfo()
        }
        .navigationDestination(for: LinkInfo.self, destination: handleLink)
        .toolbar {
            ToolbarItemGroup {
                ForEach(items) { item in
                    Button(action: {
                        path.append(item)
                    }, label: {
                        Image(systemName: item.icon)
                            .padding(4)
                    })
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

extension GameInfoView {

    @ViewBuilder
    func handleLink(_ link: LinkInfo) -> some View {
        if let linkURL = URL(string: link.url) {
            Web(url: linkURL)
        }
        else{
            if link.url.isEmpty {
                Text("URL为空")
            } else {
                Text("URL格式错误：\(link.url)")
            }
        }
    }
}
