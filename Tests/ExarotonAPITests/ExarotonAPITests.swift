//
//  ExarotonAPITests.swift
//  
//
//  Created by joker on 5/11/24.
//

import XCTest
@testable import ExarotonAPI

final class ExarotonAPITests: XCTestCase {
    
    private let client = APIClient(
        baseURL: URL(string: "https://api.exaroton.com/v1/")!,
        token: "irSTtn02Xw1I6qJWZC7JfDMWYCvBei0XxNSP3RXWkCT1zHmwD8L4XxYRPhFaYA5BoYg9YuptPHJnetQIJGBeuZrBW5flcv1yRfnk")

    func testAccount() async throws {
        guard let ret = try await client.request(.account, dataType: AccountData.self)
        else {
            XCTAssertNotNil(nil, "Response为空")
            return
        }
        XCTAssertTrue(ret.success)
        XCTAssertNil(ret.error)
        
        guard let data = ret.data
        else {
            XCTAssertNotNil(nil, "Data为空")
            return
        }
        
        XCTAssertNotNil(data.name)
        XCTAssertNotNil(data.email)
        XCTAssertTrue(data.verified)
        XCTAssertGreaterThanOrEqual(data.credits, 0)
    }
    
    func testServers() async throws {
        guard let ret = try await client.request(.servers(), dataType: [ServerData].self)
        else {
            XCTAssertNotNil(nil, "Response为空")
            return
        }
        XCTAssertTrue(ret.success)
        XCTAssertNil(ret.error)
        
        guard let data = ret.data
        else {
            XCTAssertNotNil(nil, "Data为空")
            return
        }
        XCTAssertFalse(data.isEmpty)
        if let firstServer = data.first {
            guard let ret = try await client.request(.servers(serverId: firstServer.id), dataType: ServerData.self)
            else {
                XCTAssertNotNil(nil, "Response为空")
                return
            }
            XCTAssertTrue(ret.success)
            XCTAssertNil(ret.error)
            
            guard let data = ret.data
            else {
                XCTAssertNotNil(nil, "Data为空")
                return
            }
            XCTAssertNotNil(data)
        }
    }
}
