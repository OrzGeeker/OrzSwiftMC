//
//  LauncherModel.swift
//  OrzMC
//
//  Created by joker on 2022/10/19.
//

import Foundation

class LauncherModel: ObservableObject {
    @Published var versions = [String]()
    @Published var selectedVersion: String = ""
    
    func fetchGameVersions() async throws {
        
    }
}


let mockAppModel = LauncherModel()
