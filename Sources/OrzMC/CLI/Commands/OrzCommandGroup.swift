//
//  File.swift
//  
//
//  Created by joker on 2022/1/14.
//

import ConsoleKit

struct OrzCommandGroup: AsyncCommandGroup {
    var commands: [String : AnyAsyncCommand] = [
        "client": ClientCommand(),
        "server": ServerCommand(),
        "plugin": PluginCommand(),
        "fabric": FabricCommand(),
    ]
    var help: String = "Minecraft 客户端/服务端部署工具"
}
