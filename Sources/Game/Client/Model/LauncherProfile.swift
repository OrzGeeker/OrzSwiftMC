//
//  File.swift
//  
//
//  Created by joker on 2022/4/4.
//

import Foundation
import JokerKits

public struct LauncherProfile: JsonRepresentable, Decodable, Sendable {
    let profiles: [String: Version]
    var selectedProfile: String
    let authenticationDatabase: AuthenticationDataBase
    struct Version: JsonRepresentable, Decodable {
        let created: String
        let type: String
        let name: String
        let lastVersionId: String
        let lastUsed: String
        static func now() -> String {
#if os(Linux)
            return ""
#else
            return Date().ISO8601Format(.iso8601)
#endif
        }
    }
    struct AuthenticationDataBase: JsonRepresentable, Decodable {
    }
    static func vanillaProfile(version: String) -> LauncherProfile {
        let profileVersion = Version(created: Version.now(), type: GameType.vanilla.rawValue, name: version, lastVersionId: version, lastUsed: Version.now())
        return LauncherProfile(profiles: [version:profileVersion], selectedProfile: version, authenticationDatabase: AuthenticationDataBase())
    }
    static func profile(from data: Data) throws -> LauncherProfile {
        let decoder = JSONDecoder()
        let profile = try decoder.decode(LauncherProfile.self, from: data)
        return profile
    }
    func writeToFile(_ dst: String) throws {
        if let json = try? self.jsonRepresentation(.useDefaultKeys) {
            try json.write(toFile: dst, atomically: true, encoding: .utf8)
        }
    }
}
