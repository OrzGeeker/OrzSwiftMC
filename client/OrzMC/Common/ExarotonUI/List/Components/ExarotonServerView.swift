//
//  ExarotonServerView.swift
//  OrzMC
//
//  Created by joker on 5/17/24.
//

import SwiftUI

struct ExarotonServerView: View {
    let server: ExarotonServer
    var body: some View {
        VStack(alignment: .leading) {
            if let motd = server.motd {
                Text(motd)
                    .font(.subheadline)
            }
            Divider()
            HStack {
                VStack(alignment: .leading) {
                    if let name = server.name {
                        Text(name)
                            .font(.headline)
                    }
                    if let id = server.id {
                        Text(id)
                            .font(.caption)
                    }
                    if let detail = server.detail {
                        Text(detail)
                            .font(.callout)
                    }
                }
                Spacer()
                if let status = server.serverStatus {
                    ExarotonServerStatusView(status: status)
                        .frame(width: 30, height: 30)
                }
            }
            if server.hasAddress {
                Divider()
                VStack(alignment: .leading, spacing: 4) {
                    if let staticAddress = server.staticAddress {
                        Text("\(staticAddress)")
                            .onTapGesture {
                                staticAddress.copyToPasteboard()
                            }
                    }

                    if let dynamicAddress = server.dynamicAddress {
                        Text("\(dynamicAddress)")
                            .onTapGesture {
                                dynamicAddress.copyToPasteboard()
                            }
                    }
                }
            }
        }
    }
}
#Preview {
    ExarotonServerView(
        server: .init(
            id: "123124",
            name: "JokerHub",
            address: "https://paper.jokerhub.cn:25565",
            motd: "Welcom to JokerHub Server",
            status: .init(rawValue: ServerStatus.ONLINE.rawValue),
            host: "https://paper.jokerhub.cn",
            port: 25565,
            players: .init(max: 20, count: 1, list: ["joker"]),
            software: .init(id: "1", name: "paper", version: "1.20.6"),
            shared: false
        )
    )
}
