//
//  GameInfoView.swift
//  OrzMC
//
//  Created by joker on 2024/4/28.
//

import SwiftUI

struct GameInfoView: View {
    @State private var model = ExarotonServerModel()
    var body: some View {
        NavigationStack(path: $model.path) {
            BasicInfo()
        }
        .toolbar {
            ToolView(model: $model)
        }
    }
}

#Preview {
    GameInfoView()
        .frame(width: Constants.minWidth - Constants.sidebarWidth, height: Constants.minHeight)
        .environment(GameModel())
}
