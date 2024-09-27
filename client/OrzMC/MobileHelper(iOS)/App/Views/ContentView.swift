//
//  ContentView.swift
//  OrzMC
//
//  Created by joker on 2022/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            
            Tab("Client", systemImage: "macbook") {
                Text("Client")
            }
            
            Tab("Server", systemImage: "xserve") {
                ExarotonContent()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(Model())
}
