//
//  Constants.swift
//  OrzMC
//
//  Created by wangzhizhou on 2024/12/30.
//

extension Constants {
    var string: String { self.rawValue }
}

enum Constants: String {
    case commandGroupHelp = "Minecraft 客户端/服务端部署工具"
    case chooseAGameVersion = "👉 选择一个游戏版本"
    case choosedGameVersionHint = "选择的游戏版本："
}
