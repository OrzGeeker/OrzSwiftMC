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
        case exaroton
        case other
    }
    let type: LinkType

    let name: String
}
let items: [LinkInfo] = [
    .init(url: "https://minecraft.jokerhub.cn", icon: "house", type: .home, name: "Home"),
    .init(url: "https://papermc.io/", icon: "paperplane", type: .papermc, name: "PaperMC"),
    .init(url: "https://hangar.papermc.io/", icon: "powerplug", type: .gameExt, name: "Hangar"),
    .init(url: "https://aternos.org/server/", icon: "testtube.2", type: .testServer, name: "Aternos"),
    .init(url: "https://exaroton.com/server", icon: "server.rack", type: .onlineServer, name: "Exaroton"),
]

struct GameInfoView: View {
    @AppStorage(ExarotonServerModel.accountTokenPersistentKey) var token: String = ""
    @State private var model = ExarotonServerModel()
    var body: some View {
        NavigationStack(path: $model.path) {
            BasicInfo()
        }
        .navigationDestination(for: LinkInfo.self, destination: handleLink)
        .navigationDestination(for: LinkInfo.LinkType.self, destination: { type in
            switch type {
            case .exaroton:
                ExarotonServerList(token: token)
                    .environment(model)
            default:
                EmptyView()
            }
        })
        .toolbar {
            ToolbarItemGroup {

                Button("Remote Server", systemImage: "gamecontroller") {
                    model.path.append(LinkInfo.LinkType.exaroton)
                }
                .keyboardShortcut(.init(.init("s")), modifiers: .command)

                Menu {
                    ForEach(items) { item in
                        switch item.type {
                        case .testServer, .onlineServer:
                            Link(destination: URL(string: item.url)!) {
                                Label(item.name, systemImage: item.icon)
                            }
                        default:
                            Button(item.name, systemImage: item.icon) {
                                model.path.append(item)
                            }
                        }
                    }
                    .labelStyle(.titleAndIcon)
                } label: {
                    Image(systemName: "link")
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

#Preview {
    GameInfoView()
        .frame(width: Constants.minWidth - Constants.sidebarWidth, height: Constants.minHeight)
        .environment(GameModel())
}
