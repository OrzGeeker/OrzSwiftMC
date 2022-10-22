//
//  File.swift
//  
//
//  Created by joker on 2022/10/22.
//

import Foundation
import JokerKits
import ConsoleKit

public extension Platform {
    func platformName() -> String {
        switch self {
        case .linux:
            return "linux"
        case .windows:
            return "windows"
        case .macosx:
            return "osx"
        default:
            return "unsupported"
        }
    }
    
    static let console = Terminal()
}
