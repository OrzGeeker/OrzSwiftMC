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
                .navigationSplitViewColumnWidth(min: 320, ideal: 320, max: 320)
        } detail: {
            GameInfoView()
        }
        .navigationSplitViewStyle(.prominentDetail)
    }
}

#Preview {
    LauncherUI()
        .environment(GameModel())
}
