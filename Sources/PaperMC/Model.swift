//
//  Model.swift
//  
//
//  Created by joker on 2022/10/10.
//
//  [PaperMC API v2](https://papermc.io/api/docs/swagger-ui/index.html?configUrl=/api/openapi/swagger-config)

import Foundation

public struct BuildResponse: Codable {
    public let projectId: String
    public let projectName: String
    public let version: String
    public let build: Int32
    public let time: String
    public let channel: String
    public let promoted: Bool
    public let changes: [Change]
    public let downloads: [String: Download]
}

public struct BuildsResponse: Codable {
    public let projectId: String
    public let projectName: String
    public let version: String
    public let builds: [VersionBuild]
}

public struct Change: Codable {
    public let commit: String
    public let summary: String
    public let message: String
}

public struct Download: Codable {
    public let name: String
    public let sha256: String
}

public struct ProjectResponse: Codable {
    public let projectId: String
    public let projectName: String
    public let versionGroups: [String]
    public let versions: [String]
}

public struct ProjectsResponse: Codable {
    let projects: [String]
}

public struct VersionBuild: Codable {
    public let build: Int32
    public let time: String
    public let channel: String
    public let promoted: Bool
    public let changes: [Change]
    public let downloads: [String: Download]
}

public struct VersionFamilyBuild: Codable {
    public let version: String
    public let build: Int32
    public let time: String
    public let channel: String
    public let promoted: Bool
    public let changes: [Change]
    public let downloads: [String: Download]
}

public struct VersionFamilyBuildsResponse: Codable {
    public let projectId: String
    public let projectName: String
    public let versionGroup: String
    public let versions: [String]
    public let builds: [VersionFamilyBuild]
}

public struct VersionFamilyResponse: Codable {
    public let projectId: String
    public let projectName: String
    public let versionGroup: String
    public let versions: [String]
}

public struct VersionResponse: Codable {
    public let projectId: String
    public let projectName: String
    public let version: String
    public let builds: [Int32]
}
