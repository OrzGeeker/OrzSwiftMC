//
//  File.swift
//  
//
//  Created by joker on 2022/4/4.
//

import Foundation
import JokerKits

struct LauncherProfile: JsonRepresentable {
    let profiles: [String: Version]
    let selectedProfile: String
    let authenticationDatabase = AuthenticationDataBase()
    struct Version: JsonRepresentable {
        let created = Self.now()
        let type: GameType = .vanilla
        let name: String
        let lastVersionId: String
        let lastUsed = Self.now()
        static func now() -> String {
            return Date().ISO8601Format(.iso8601)
        }
    }
    struct AuthenticationDataBase: JsonRepresentable {
    }
    static func vanillaProfile(version: String) -> LauncherProfile {
        let profileVersion = Version(name: version, lastVersionId: version)
        return LauncherProfile(profiles: [version:profileVersion], selectedProfile: version)
    }
    func writeToFile(_ dst: String) throws {
        if let json = try? self.jsonRepresentation(.useDefaultKeys) {
            try json.write(toFile: dst, atomically: true, encoding: .utf8)
        }
    }
}
