//
//  ExarotonAPI.swift
//
//
//  Created by joker on 5/11/24.
//
//
//  exaroton API Doc: https://developers.exaroton.com/

import Foundation
public struct APIClient {
    public let baseURL: URL
    public let token: String
}
extension APIClient {
    static let jsonEncoder = {
        let jsonEncoder = JSONEncoder()
        return jsonEncoder
    }()
    static let jsonDecoder = {
        let jsonDecoder = JSONDecoder()
        return jsonDecoder
    }()
    static let session = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
    func request<DataType: Codable>(_ endpoint: EndPoint, dataType: DataType.Type) async throws -> Response<DataType>? {
        var req = URLRequest(url: baseURL.appending(path: endpoint.path))
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.httpMethod = endpoint.httpMethod.rawValue
        if let postBody = endpoint.httpBodyModel {
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.httpBody = try APIClient.jsonEncoder.encode(postBody)
        }
        let (data, _) = try await APIClient.session.data(for: req)
        print(String(data:data, encoding: .utf8)!)
        return try APIClient.jsonDecoder.decode(Response<DataType>.self, from: data)
    }
}
