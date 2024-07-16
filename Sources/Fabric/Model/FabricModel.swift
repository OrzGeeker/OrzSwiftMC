//
//  FabricModel.swift
//  
//
//  Created by joker on 2022/4/5.
//

import Foundation

public struct FabricModel: Codable, Sendable {
    public let id: String
    public let inheritsFrom: String
    public let releaseTime: String
    public let time: String
    public let type: String
    public let mainClass: String
    public let arguments: Argument
    public let libraries: [Library]
    public struct Argument: Codable, Sendable {
        public let game: [String]
        public let jvm: [String]
    }
    public struct Library: Codable, Sendable {
        public let name: String
        public let url: URL
        
        
        public var downloadURL: URL {
            var url = self.url
            let components = self.name.split(separator: ":")
            
            if let firstPart = components.first?.split(separator: ".") {
                let secondPart = components.dropFirst()
                
                
                firstPart.forEach { pathComponent in
                    url.appendPathComponent(String(pathComponent))
                }
                
                secondPart.forEach { pathComponent in
                    url.appendPathComponent(String(pathComponent))
                }
                
                let filename = secondPart.joined(separator: "-")
                url.appendPathComponent(filename)
                url.appendPathExtension("jar")
            }
        
            return url
        }
    }
}
