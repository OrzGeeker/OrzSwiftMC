enum Constants: String {
    
    // Console Common
    case chooseAGameVersion = "👉 选择一个游戏版本"
    case choosedGameVersionHint = "选择的游戏版本："
    
    // Console Input & Output
    case uiInputUsername = "输入一个用户名："
    case uiInputAuthAccount = "输入正版帐号(如无可以直接回车)："
    case uiInputAuthPassword = "输入正版密码((如无可以直接回车))："
    case uiOutputUsername = "游戏用户名："
    case uiOutputAuthAccount = "正版帐号："
    case uiOutputAuthPassword = "正版密码："
    case uiOutputPasswordMask = "*"
    case uiOutputServerType = "服务器类型: "
    case uiOutputServerStopped = "服务端已停止: pid = "
    case uiOutputUnspecifyOutputPath = "未指定有效的插件下载目录路径"
    case uiOutputDownloading = "正在下载中......"
    case uiOutputDownloaded = "下载完成"
    case uiOutputDownloadedToDir = "文件已下载到目录："
    case uiOutputPluginSearchNoResult = "搜索无结果"
    // Common
    case commandGroupHelp = "Minecraft 客户端/服务端部署工具"
    case DebugHelp = "调试模式"
    case VersionHelp = "游戏版本号"
    
    // Client
    case clientHelp = "客户端相关命令"
    case clientAuthHelp = "是否验证正版帐号(默认不验证)"
    case clientUsernameHelp = "登录用户名"
    case clientMinMemHelp = "客户端运行使用的最小内存，默认为："
    case clientMaxMemHelp = "客户端运行使用的最大内存，默认为："
    
    // Server
    case serverHelp = "服务端相关"
    case serverGUIHelp = "服务器以GUI方式启动"
    case serverForceUpgradeHelp = "强制升级地图"
    case serverTypeHelp = "服务器类型: paper/vanilla, 默认：paper"
    case serverMinMemHelp = "服务端运行使用的最小内存，默认为："
    case serverMaxMemHelp = "服务端运行使用的最大内存，默认为："
    case serverOnlineModeHelp = "服务端运行时是否使用Online模式，默认为：false"
    case serverJarHelp = "查看服务端jar包的帮助信息"
    case serverJarOptionHelp = "jar文件运行时额外选项, 字符串参数以 a: 开头，例如：--jar-opts \"a:--help\""
    case serverDemoModeHelp = "演示模式"
    case serverKillAllHelp = "杀死所有正在运行的服务端"
    
    // Fabric
    case fabricHelp = "安装Fabric"
    case fabricServerHelp = "安装服务端Fabric，不指定默认安装客户端Fabric"
    case fabricInstallerHelp = "Fabric安装器文件下载URL链接或者本地文件URL"
    case fabricVersionHelp = "指定游戏版本号"
    
    // Plugin
    case pluginHelp = "使用HangarAPI搜索&下载需要的服务插件"
    case pluginListHelp = "列出所有需要下载的插件信息"
    case pluginOutputHelp = "下载插件后要保存到的目录路径"
    case pluginSearchHelp = "按插件名称搜索Hangar"
    case pluginSearchResultCountHelp = "指定搜索结果最大数量, 默认为："
    case pluginSpecifiedGameVersionHelp = "指定插件需要适配的游戏版本号"
}

extension Constants {
    static let clientMinMemDefault = "512M"
    static let clientMaxMemDefault = "2G"
    static let serverMinMemDefault = "1G"
    static let serverMaxMemDefault = "1G"
    static let pluginSearchResultCountMaxDefault: Int64 = 3
}

extension Constants {
    var string: String {
        switch self {
        case .clientMinMemHelp:
            self.rawValue + Self.clientMinMemDefault
        case .clientMaxMemHelp:
            self.rawValue + Self.clientMaxMemDefault
        case .serverMinMemHelp:
            self.rawValue + Self.serverMinMemDefault
        case .serverMaxMemHelp:
            self.rawValue + Self.serverMaxMemDefault
        case .pluginSearchResultCountHelp:
            self.rawValue + String(Self.pluginSearchResultCountMaxDefault)
        default:
            self.rawValue
        }
    }
}
