//
//  Version+.swift
//  OrzMC
//
//  Created by joker on 2024/4/28.
//

import SwiftUI
import Mojang

extension Version {
    var typeTagColor: Color {
        if type.contains("release") {
            return .accentColor
        } else if type.contains("snapshot") {
            return .mint
        } else if type.contains("alpha") {
            return .red
        } else if type.contains("beta") {
            return .orange
        } else {
            return .gray
        }
    }
}
