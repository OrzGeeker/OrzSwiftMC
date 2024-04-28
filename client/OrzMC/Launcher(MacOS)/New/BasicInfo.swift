//
//  BasicInfo.swift
//  OrzMC
//
//  Created by joker on 2024/4/28.
//

import SwiftUI
import Mojang

struct BasicInfo: View {

    @Environment(GameModel.self) private var model

    @State private var gameInfo: GameInfo?

    var body: some View {
        VStack {
            if let gameInfo {
                Text("\(gameInfo.javaVersion.majorVersion) - \(gameInfo.javaVersion.component)")
            } else {
                Text("Retry Again Later")
            }
        }
        .navigationTitle(model.detailTitle)
        .onChange(of: model.selectedVersion) {
            Task {
                guard let selectedVersion = model.selectedVersion, let gameInfo = try? await selectedVersion.gameInfo
                else { return }

                self.gameInfo = gameInfo
            }
        }
    }
}
