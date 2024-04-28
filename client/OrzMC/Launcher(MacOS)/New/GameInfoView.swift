//
//  GameInfoView.swift
//  OrzMC
//
//  Created by joker on 2024/4/28.
//

import SwiftUI

struct GameInfoView: View {
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            BasicInfo()
        }
    }
}

