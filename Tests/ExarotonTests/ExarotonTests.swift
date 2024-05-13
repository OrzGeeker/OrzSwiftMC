//
//  ExarotonTests.swift
//
//
//  Created by joker on 5/11/24.
//
//
//  exaroton API Doc: https://developers.exaroton.com/

import XCTest
@testable import Exaroton

final class ExarotonTests: XCTestCase {

    let client = APIClient(
        baseURL: URL(string: "https://api.exaroton.com/v1")!,
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
        checkResponse(response)
    }

    func testGetServerLog() async throws {
        let response = try await client.request(.servers(serverId: serverId, op: .logs), dataType: ServerLogData.self)
        checkResponse(response)
    }

    func testUploadServerLog() async throws {
        let response = try await client.request(.servers(serverId: serverId, op: .logsShare), dataType: ServerLogShareData.self)
        guard let data = checkResponse(response)
        else { return }
        XCTAssertFalse(data.id.isEmpty)
        XCTAssertFalse(data.url.isEmpty)
        XCTAssertFalse(data.raw.isEmpty)
    }

    func testGetServerRAM() async throws {
        let response = try await client.request(.servers(serverId: serverId, op: .ram()), dataType: ServerRAMData.self)
        guard let data = checkResponse(response)
        else { return }
        XCTAssertTrue(data.ram > 0)
    }
    
    func testChangeServerRAM() async throws {
        let dstRAM = 2
        let response = try await client.request(.servers(serverId: serverId, op: .ram(.init(ram: dstRAM))), dataType: ServerRAMData.self)
        guard let data = checkResponse(response)
        else { return }
        XCTAssertTrue(data.ram == dstRAM)
    }

    func testGetServerMOTD() async throws {
        let response = try await client.request(.servers(serverId: serverId, op: .motd()), dataType: ServerMOTDData.self)
        guard let data = checkResponse(response)
        else { return }
        XCTAssertFalse(data.motd.isEmpty)
    }

    func testChangeServerMOTD() async throws {
        let dstMOTD = "§b🗡 §7欢迎来到§ajokerhub§7的服务器！§b⛏"
        let response = try await client.request(.servers(serverId: serverId, op: .motd(.init(motd: dstMOTD))), dataType: ServerMOTDData.self)
        guard let data = checkResponse(response)
        else { return }
        XCTAssertTrue(data.motd == dstMOTD)
    }

    func testStartServer() async throws {
        let response = try await client.request(.servers(serverId: serverId, op: .start()), dataType: String.self)
        XCTAssertNotNil(response)
    }

    func testStartServerWithOwnCredits() async throws {
        let response = try await client.request(.servers(serverId: serverId, op: .start(.init(useOwnCredits: true))), dataType: String.self)
        XCTAssertNotNil(response)
    }

    func testStopServer() async throws {
        let response = try await client.request(.servers(serverId: serverId, op: .stop), dataType: String.self)
        XCTAssertNotNil(response)
    }

    func testRestartServer() async throws {
        let response = try await client.request(.servers(serverId: serverId, op: .restart), dataType: String.self)
        XCTAssertNotNil(response)
    }

    func testRunServerCommand() async throws {
        let response = try await client.request(.servers(serverId: serverId, op: .command(.init(command: "plugins"))), dataType: String.self)
        XCTAssertNotNil(response)
    }

    func testGetPlaylistTypes() async throws {
        let response = try await client.request(.servers(serverId: serverId, op: .playlist()), dataType: [String].self)
        guard let data = checkResponse(response)
        else { return }
        XCTAssertFalse(data.isEmpty)
    }

    func testGetPlaylistOfWhitelist() async throws {
        let response = try await client.request(.servers(serverId: serverId, op: .playlist("whitelist")), dataType: [String].self)
        guard let data = checkResponse(response)
        else { return }
        XCTAssertFalse(data.isEmpty)
    }

    let testPlayerName = "ExarotonAPI_Tester_Player"
    func testAddPlayerIntoWhitelist() async throws {
        let response = try await client.request(.servers(serverId: serverId, op: .playlist("whitelist", op: .add(.init(entries: [testPlayerName])))), dataType: [String].self)
        guard let data = checkResponse(response)
        else { return }
        XCTAssertTrue(data.contains(testPlayerName))
    }
    func testDeletePlayerIntoWhitelist() async throws {
        let response = try await client.request(.servers(serverId: serverId, op: .playlist("whitelist", op: .delete(.init(entries: [testPlayerName])))), dataType: [String].self)
        guard let data = checkResponse(response)
        else { return }
        XCTAssertFalse(data.contains(testPlayerName))
    }

    func testListCreditPools() async throws {
        let response = try await client.request(.creditPool(), dataType: [CreditPool].self)
        XCTAssertNotNil(response)
    }

    let poolId = "qWE6dfsMX4TxT6g4"
    func testGetACreditPool() async throws {
        let response = try await client.request(.creditPool(poolId: poolId), dataType: CreditPool.self)
        guard let data = checkResponse(response)
        else { return }
        XCTAssertNotNil(data.id)
    }
    func testListCreditPoolMembers() async throws {
        let response = try await client.request(.creditPool(poolId: poolId, op: .members), dataType: [CreditPoolMember].self)
        XCTAssertNotNil(response)
    }
    func testListCreditPoolServers() async throws {
        let response = try await client.request(.creditPool(poolId: poolId, op: .servers), dataType: [ServerData].self)
        XCTAssertNotNil(response)
    }
}

extension ExarotonTests {

    @discardableResult
    func checkResponse<DataType: Codable>(_ response: Response<DataType>?) -> DataType? {
        guard let ret = response
        else {
            XCTAssertNotNil(nil)
            return nil
        }
        XCTAssertTrue(ret.success)
        XCTAssertNil(ret.error)
        return checkResponseData(ret.data)
    }

    @discardableResult
    func checkResponseData<DataType: Codable>(_ data: DataType?) -> DataType? {
        guard let data
        else {
            XCTAssertNotNil(nil)
            return nil
        }
        return data
    }
}
