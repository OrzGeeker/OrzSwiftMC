//
//  ContentView.swift
//  OrzMC
//
//  Created by joker on 2022/10/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("TOKEN") var token: String = ""
    @State private var model = ExarotonServerModel()
    var body: some View {
        NavigationStack(path: $model.path) {
            ExarotonServerList(token: token)
                .navigationDestination(for: ExarotonServer.self, destination: { server in
                    ExarotonServerDetail(server: server)
                        .environment(model)
                })
                .navigationDestination(for: ExarotonCreditPool.self, destination: { creditPool in
                    ExarotonCreditPoolDetail(creditPool: creditPool)
                        .environment(model)
                })
                .environment(model)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
