//
//  ExarotonServerModel+HTTP.swift
//  OrzMC
//
//  Created by joker on 2024/5/20.
//

import ExarotonHTTP

extension ExarotonServerModel {
    func fetchServers() async {
        do {
            let response = try await httpClient.getServers()
            switch response {
            case .ok(let ok):
                if let data = try ok.body.json.data {
                    servers = data
                }
            default:
                break
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func startServer(serverId: String) async -> Bool {
        do {
            let reponse = try await httpClient.getStartServer(path: .init(serverId: serverId))
            switch reponse {
            case .ok(let ok):
                let json = try ok.body.json
                return json.success ?? false
            default:
                return false
            }
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }

    func stopServer(serverId: String) async -> Bool {
        do {
            let reponse = try await httpClient.stopServer(path: .init(serverId: serverId))
            switch reponse {
            case .ok(let ok):
                let json = try ok.body.json
                return json.success ?? false
            default:
                return false
            }
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }

    func restartServer(serverId: String) async -> Bool {
        do {
            let reponse = try await httpClient.restartServer(path: .init(serverId: serverId))
            switch reponse {
            case .ok(let ok):
                let json = try ok.body.json
                return json.success ?? false
            default:
                return false
            }
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }

    func fetchCreditPools() async {
        do {
            let response = try await httpClient.getCreditPools()
            switch response {
            case .ok(let ok):
                if let data = try ok.body.json.data {
                    creditPools = data
                }
            default:
                break
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func fetchCreditPoolInfo(_ pool: ExarotonCreditPool) async -> (ExarotonCreditPool?, [ExarotonCreditMember]?, [ExarotonServer]?)? {
        guard let poolId = pool.id
        else {
            return nil
        }
        do {
            async let poolResponse = try await httpClient.getCreditPool(path: .init(poolId: poolId))
            async let membersResponse = try await httpClient.getCreditPoolMembers(path: .init(poolId: poolId))
            async let serversResponse = try await httpClient.getCreditPoolServers(path: .init(poolId: poolId))
            switch (try await poolResponse, try await membersResponse, try await serversResponse) {
            case (.ok(let poolOk), .ok(let membersOk), .ok(let serversOk)):
                let pool = try poolOk.body.json.data
                let members = try membersOk.body.json.data
                let servers = try serversOk.body.json.data
                return (pool, members, servers)
            default:
                return (nil, nil, nil)
            }
        } catch let error {
            print(error.localizedDescription)
            return (nil, nil, nil)
        }
    }

    func getRAM(serverId: String) async -> Int32? {
        do {
            let response = try await httpClient.getServerRam(path: .init(serverId: serverId))
            switch response {
            case .ok(let ok):
                let data = try ok.body.json.data
                return data?.ram
            default:
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func changeRAM(serverId: String, ramGB: Int32) async -> Int32? {
        do {
            let response = try await httpClient.postServerRam(path: .init(serverId: serverId), body: .json(.init(ram: ramGB)))
            switch response {
            case .ok(let ok):
                let data = try ok.body.json.data
                return data?.ram
            default:
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
