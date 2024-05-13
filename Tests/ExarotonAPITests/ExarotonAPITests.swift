//
//  ExarotonAPITests.swift
//
//
//  Created by joker on 5/11/24.
//
//
//  exaroton API Doc: https://developers.exaroton.com/

import XCTest
@testable import ExarotonAPI

final class ExarotonAPITests: XCTestCase {

    let client = APIClient(
        baseURL: URL(string: "https://api.exaroton.com/v1/")!,
        token: "irSTtn02Xw1I6qJWZC7JfDMWYCvBei0XxNSP3RXWkCT1zHmwD8L4XxYRPhFaYA5BoYg9YuptPHJnetQIJGBeuZrBW5flcv1yRfnk")

    func testAccount() async throws {
        let response = try await client.request(.account, dataType: AccountData.self)
        guard let account = checkResponse(response)
        else { return }
        XCTAssertNotNil(account.name)
        XCTAssertNotNil(account.email)
        XCTAssertTrue(account.verified)
        XCTAssertGreaterThanOrEqual(account.credits, 0)
    }

    func testServers() async throws {
        let response = try await client.request(.servers(), dataType: [ServerData].self)
        guard let servers = checkResponse(response)
        else { return }
        XCTAssertFalse(servers.isEmpty)
    }


    let serverId = "ATMiLQGZ43vW2k3W"

    func testServer() async throws {
        let response = try await client.request(.servers(serverId: serverId), dataType: ServerData.self)
        guard let data = checkResponse(response)
        else { return }
        XCTAssertNotNil(data)
    }

    func testGetServerLog() async throws {
        let response = try await client.request(.servers(serverId: serverId, op: .logs), dataType: ServerLogData.self)
        guard let data = checkResponse(response)
        else { return }
        XCTAssertNotNil(data)
    }

    func testUploadServerLog() async throws {
        let response = try await client.request(.servers(serverId: serverId, op: .logsShare), dataType: ServerLogShareData.self)
        guard let data = checkResponse(response)
        else { return }
        XCTAssertNotNil(data)
        XCTAssertFalse(data.id.isEmpty)
        XCTAssertFalse(data.url.isEmpty)
        XCTAssertFalse(data.raw.isEmpty)
    }

    func testGetServerRAM() async throws {
        let response = try await client.request(.servers(serverId: serverId, op: .ram()), dataType: ServerRAMData.self)
        guard let data = checkResponse(response)
        else { return }
        XCTAssertNotNil(data)
        XCTAssertTrue(data.ram > 0)
    }
    
    func testChangeServerRAM() async throws {
        let dstRAM = 4
        let response = try await client.request(.servers(serverId: serverId, op: .ram(.init(ram: dstRAM))), dataType: ServerRAMData.self)
        guard let data = checkResponse(response)
        else { return }
        XCTAssertNotNil(data)
        XCTAssertTrue(data.ram == dstRAM)
    }
}

extension ExarotonAPITests {

    func checkResponse<DataType: Codable>(_ response: Response<DataType>?) -> DataType? {
        guard let ret = response
        else {
            XCTAssertNotNil(nil)
            return nil
        }
        XCTAssertTrue(ret.success)
        XCTAssertNil(ret.error)

        guard let data = ret.data
        else {
            XCTAssertNotNil(nil)
            return nil
        }
        return data
    }
}
