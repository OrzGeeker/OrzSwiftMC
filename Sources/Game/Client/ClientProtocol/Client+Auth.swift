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
        
        let authParam =  Mojang.AuthAPI.AuthReqParam.init(
            agent: Mojang.AuthAPI.AuthReqParam.Agent(),
            username: accountName,
            password: accountPassword
        )
        guard let data = try await Mojang.AuthAPI.authenticate(reqParam: authParam).data
        else {
            return false
        }
        
        let authResp = try JSONDecoder().decode(Mojang.AuthAPI.AuthRespone.self, from: data)
        self.clientInfo.clientToken = authResp.clientToken
        self.clientInfo.accessToken = authResp.accessToken
        
        return true
    }
}
