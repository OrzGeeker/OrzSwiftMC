//
//  PaperMCAPI.swift
//
//
//  Created by joker on 2024/1/14.
//

import OpenAPIRuntime
import OpenAPIURLSession


/// [PaperMC API](https://api.papermc.io/docs/swagger-ui/index.html?configUrl=/openapi/swagger-config)
/// [openapi.json](https://api.papermc.io/openapi)
public struct PaperMCAPI {

    private let client = Client(serverURL: try! Servers.server1(), transport: URLSessionTransport())

    public init() {}
}
