//
//  ExarotonServerRuntimeView.swift
//  OrzMC
//
//  Created by joker on 2024/5/21.
//

import SwiftUI

struct ExarotonServerRuntimeView: View {
    let server: ExarotonServer
    var body: some View {
        VStack {
            if let motd = server.motd {
                LabeledContent("MOTD", value: motd)
            }
            if server.hasAddress {
                LabeledContent {
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
                } label: {
                    Text("Address")
                }
            }
            if let playerList = server.players?.list, !playerList.isEmpty {
                LabeledContent {
                    ForEach(playerList, id: \.self) { playerName in
                        Text(playerName)
                    }
                } label: {
                    Text("Players")
                }
            }
        }
    }
}
