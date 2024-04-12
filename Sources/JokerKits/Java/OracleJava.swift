//
//  File.swift
//  
//
//  Created by joker on 2022/1/15.
//

import Foundation

public enum JDK {
    case jdk17
    
    var downloadUrl: URL {
        get async throws {
            return URL(fileURLWithPath: ".")
        }
    }
    
    enum JDKError: Error {
        case unsupportOS
        case unsupportArch
    }
}

/// JDK安装
///
/// [Oracle Java Installation Guide](https://docs.oracle.com/en/java/javase/17/install/index.html)
///
/// [Oracle JDK Script Friendly urls](https://www.oracle.com/java/technologies/jdk-script-friendly-urls/)
public struct OracleJava {
    
    /// 获取当前系统安装的Java版本信息
    /// - Returns: 返回的Java版本信息
    static public func currentJavaVersion() throws -> String {
        return try Shell.runCommand(with: ["java", "--version"])
    }
    
    
    /// 获取当前设备上安装的所有JVM信息
    /// - Returns: 返回值，字符串
    static public func installedJVM() throws -> String {
        return try Shell.run(path: "/usr/libexec/java_home", args: ["-V"])
    }
    
    static public func installedJavaVersions() throws -> [String]? {
        var ret: [String]? = nil
        
        switch Platform.os() {
        case .macosx:
            let javaDir = "/Library/Java/JavaVirtualMachines"
            if let jdks = try FileManager.allSubDir(in: javaDir) {
                ret = jdks.map { NSString.path(withComponents: [javaDir, $0]) }
            }
        default:
            break
        }
        return ret;
    }

    static public func uninstallJava(version: String) throws {

        guard let javas = try installedJavaVersions()?.filter({ $0.contains(version) })
        else {
            return
        }

        for java in javas {
            let ret = try Shell.runCommand(with: [
                "sudo expect",
                "rm", "-rf",
                java
            ])
            print(ret)
        }
    }

    static public func uninstallAllJava() throws {
        guard let javas = try installedJavaVersions()
        else {
            return
        }
        for java in javas {
            let ret = try Shell.runCommand(with: [
                "sudo expect",
                "rm", "-rf",
                java
            ])
            print(ret)
        }
    }
}
