//
//  File.swift
//  
//
//  Created by joker on 2022/10/22.
//

import Foundation
import MojangAPI

extension Client {
    /// 授权验证
    public mutating func auth() async throws -> Bool {
        guard let accountName = clientInfo.accountName, let accountPassword = self.clientInfo.accountPassword
        else {
            return false
        }
        let agent = AuthAgent(name: "minecraft", version: 1)
        let reqParam = AuthReqParam(agent: agent, username: accountName, password: accountPassword)
        let body = AuthReqBody.json(reqParam)
        let authResp = try await Mojang.auth(action: .authenticate, reqBody: body)
        self.clientInfo.clientToken = authResp.clientToken
        self.clientInfo.accessToken = authResp.accessToken
        
        return true
    }
}
