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
            let ret: Data? = await withCheckedContinuation { continuation in
                AF.request(self).responseData { response in
                    switch response.result {
                    case .success(let data):
                        continuation.resume(with: .success(data))
                    default:
                        continuation.resume(with: .success(nil))
                    }
                }
            }
            return ret
        }
    }
}
