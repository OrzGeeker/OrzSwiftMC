//
//  ExarotonServerPlayList.swift
//  OrzMC
//
//  Created by joker on 2024/5/21.
//

import SwiftUI

struct ExarotonServerPlayList: View {
    let playlist: [String]
    var body: some View {
        List {
            ForEach(playlist, id: \.self) { playerName in
                Text(playerName)
            }
        }
    }
}
