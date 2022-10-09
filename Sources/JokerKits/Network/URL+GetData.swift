//
//  URL+GetData.swift
//  
//
//  Created by wangzhizhou on 2021/12/26.
//

import Foundation
import Alamofire

public extension URL {
    var getData: Data? {
        get async throws {
            return try await AF.request(self).serializingData().value
        }
    }
}
