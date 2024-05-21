//
//  ExarotonServerListLinkItem.swift
//  OrzMC
//
//  Created by joker on 2024/5/20.
//

import SwiftUI

struct ExarotonServerListLinkItem: View {
    @Environment(ExarotonServerModel.self) var model
    let server: ExarotonServer
    var body: some View {
        NavigationLink {
            ExarotonServerDetail(server: server)
                .environment(model)
        } label: {
            ExarotonServerView(server: server)
        }
    }
}
