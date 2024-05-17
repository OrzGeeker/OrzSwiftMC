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
                .navigationSplitViewColumnWidth(Constants.sidebarWidth)
        } detail: {
            GameInfoView()
        }
        .navigationSplitViewStyle(.prominentDetail)
        .feedbackToAuthor(email: "824219521@qq.com")
    }
}

#Preview {
    LauncherUI()
        .environment(GameModel())
}
