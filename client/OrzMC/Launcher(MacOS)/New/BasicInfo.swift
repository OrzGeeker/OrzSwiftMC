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

    var body: some View {
        VStack {
            if let javaMajorVersion = model.selectedGameJavaMajorVersionRequired {
                Text("\(javaMajorVersion)")
            } else {
                Text("Retry Again Later")
            }
        }
        .navigationTitle(model.detailTitle)
    }
}
