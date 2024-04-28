//
//  LauncherUI.swift
//  OrzMC
//
//  Created by joker on 2022/10/19.
//

import SwiftUI

struct LauncherUI: View {

    var body: some View {

        NavigationSplitView {

            GameView()
                .navigationSplitViewColumnWidth(min: 300, ideal: 300, max: 300)

        } detail: {
            Text("Detail")
        }
    }
}

#Preview {
    LauncherUI()
        .environment(GameModel())
}
