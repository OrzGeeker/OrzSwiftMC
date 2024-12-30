//
//  File.swift
//  
//
//  Created by joker on 2022/10/22.
//

import Utils

public extension Platform {
    func platformName() -> String {
        switch self {
        case .linux:
            return "linux"
        case .windows:
            return "windows"
        case .macOS:
            return "osx"
        default:
            return "unsupported"
        }
    }
}
