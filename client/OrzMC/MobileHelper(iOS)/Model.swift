//
//  Model.swift
//  OrzMC
//
//  Created by joker on 2022/10/25.
//

import Foundation

class Model: ObservableObject {
    static let shared = Model()
    static let mock = Model()
    private init() {}
}