//
//  Version+.swift
//  OrzMC
//
//  Created by joker on 2024/4/28.
//

import SwiftUI
import MojangAPI

extension Version {
    var typeTagColor: Color {
        switch buildType {
        case .release:
            return .accentColor
        case .snapshot:
            return .mint
        case .oldAlpha:
            return .red
        case .oldBeta:
            return .orange
        }
    }
}
