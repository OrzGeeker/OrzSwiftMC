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
enum MIMEType: String {
    case json = "application/json"
    case zip = "application/zip"
    case data = "application/octet-stream"
    case text = "text/plain"
}
