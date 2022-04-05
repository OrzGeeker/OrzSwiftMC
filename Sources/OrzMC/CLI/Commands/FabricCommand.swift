//
//  File.swift
//  
//
//  Created by joker on 2022/4/4.
//

import Foundation
import ConsoleKit
import Alamofire

//struct FabricCommand: Command {
//    var help: String = "安装Fabric"
//    
//    struct Signature: CommandSignature {
//        @Flag(name: "client", short: "c", help: "安装客户端Fabric")
//        var client: Bool
//        
//        @Option(name: "loader", short: "l", help: "安装指定Fabric loader")
//        var loader: String?
//    }
//    
//    func run(using context: CommandContext, signature: Signature) throws {
//        if let loader = signature.loader, let loaderURL = URL(string: loader) {
//            try DispatchGroup().syncExecAndWait {
//                
//            } errorClosure: { error in
//                
//            }
//        }
//        else {
//            context.console.error("没有指定Fabric Loader的下载地址，使用-l选项指定")
//        }
//    }
//}
