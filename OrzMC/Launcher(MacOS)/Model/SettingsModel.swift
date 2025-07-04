//
//  SettingsModel.swift
//  OrzMC
//
//  Created by wangzhizhou on 2024/9/26.
//

import Foundation

@Observable
final class SettingsModel {
    
    var enableJVMDebugger: Bool = false
    
    var jvmDebuggerArgs: String = ""
}
