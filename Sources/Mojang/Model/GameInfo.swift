//
//  File.swift
//  
//
//  Created by wangzhizhou on 2021/12/25.
//

import Foundation
import JokerKits

public struct GameInfo: MojangCodable {
    public let arguments: Argument
    public let assetIndex: AssetIndex
    public let assets: String
    public let complianceLevel: Int
    public let downloads: Download
    public let id: String
    public let javaVersion: JavaVersion
    public let libraries: [JavaLibrary]
    public let logging: Logging
    public let mainClass: String
    public let minimumLauncherVersion: Int
    public let releaseTime: String
    public let time: String
    public let type: String
}
