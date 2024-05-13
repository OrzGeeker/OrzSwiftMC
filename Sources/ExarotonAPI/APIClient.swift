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
    func request<DataType: Codable>(_ endpoint: EndPoint, dataType: DataType.Type) async throws -> Response<DataType>? {
        var req = URLRequest(url: URL(string: endpoint.urlComponent, relativeTo: baseURL)!)
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.httpMethod = endpoint.httpMethod.rawValue
        if let postBody = endpoint.postBodyModel {
            req.setValue("Content-Type", forHTTPHeaderField: "application/json")
            req.httpBody = try APIClient.jsonEncoder.encode(postBody)
        }
        let (data, response) = try await URLSession.shared.data(for: req)
        guard let resp = response as? HTTPURLResponse, resp.statusCode == 200
        else {
            return nil
        }
        print(String(data:data, encoding: .utf8)!)
        return try APIClient.jsonDecoder.decode(ExarotonAPI.Response<DataType>.self, from: data)
    }
}
