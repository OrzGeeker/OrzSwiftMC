//
//  ContentView.swift
//  OrzMC
//
//  Created by joker on 2022/10/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("TOKEN") var token: String = ""
    var body: some View {
        NavigationView {
            ExarotonServerList(token: token)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
