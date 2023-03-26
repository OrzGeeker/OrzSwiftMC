//
//  ContentView.swift
//  OrzMC
//
//  Created by joker on 2022/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            Text("Side Bar")
        } content: {
            Text("Content View")
        } detail: {
            Text("Detail View")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
