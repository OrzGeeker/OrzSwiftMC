//
//  File.swift
//  
//
//  Created by joker on 5/12/24.
//

import Foundation
struct Response<DataType: Codable>: Codable {
    let success: Bool
    var error: String?
    var data: DataType?
}
