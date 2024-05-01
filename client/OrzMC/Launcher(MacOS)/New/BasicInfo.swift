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
           Text("Basic Info")
        }
        .navigationTitle(model.detailTitle)
    }
}
