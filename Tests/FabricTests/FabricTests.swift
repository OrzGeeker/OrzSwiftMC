//
//  FabricTests.swift
//
//
//  Created by joker on 2022/4/5.
//

import Testing
import Fabric

final class FabricTests {
    @Test
    func download() throws {
        let jsonContent = """
    {
        "id":"fabric-loader-0.13.3-1.18.2",
        "inheritsFrom":"1.18.2",
        "releaseTime":"2022-04-03T23:27:33+0000",
        "time":"2022-04-03T23:27:33+0000",
        "type":"release",
        "mainClass":"net.fabricmc.loader.impl.launch.knot.KnotClient",
        "arguments":{
            "game":[
    
            ],
            "jvm":[
                "-DFabricMcEmu= net.minecraft.client.main.Main "
            ]
        },
        "libraries":[
            {
                "name":"net.fabricmc:tiny-mappings-parser:0.3.0+build.17",
                "url":"https://maven.fabricmc.net/"
            },
            {
                "name":"net.fabricmc:sponge-mixin:0.11.2+mixin.0.8.5",
                "url":"https://maven.fabricmc.net/"
            },
            {
                "name":"net.fabricmc:tiny-remapper:0.8.1",
                "url":"https://maven.fabricmc.net/"
            },
            {
                "name":"net.fabricmc:access-widener:2.1.0",
                "url":"https://maven.fabricmc.net/"
            },
            {
                "name":"org.ow2.asm:asm:9.2",
                "url":"https://maven.fabricmc.net/"
            },
            {
                "name":"org.ow2.asm:asm-analysis:9.2",
                "url":"https://maven.fabricmc.net/"
            },
            {
                "name":"org.ow2.asm:asm-commons:9.2",
                "url":"https://maven.fabricmc.net/"
            },
            {
                "name":"org.ow2.asm:asm-tree:9.2",
                "url":"https://maven.fabricmc.net/"
            },
            {
                "name":"org.ow2.asm:asm-util:9.2",
                "url":"https://maven.fabricmc.net/"
            },
            {
                "name":"net.fabricmc:intermediary:1.18.2",
                "url":"https://maven.fabricmc.net/"
            },
            {
                "name":"net.fabricmc:fabric-loader:0.13.3",
                "url":"https://maven.fabricmc.net/"
            }
        ]
    }
    """
        let launcherModel = try Fabric.launcherConfig(jsonContent.data(using: .utf8)!)
        #expect(launcherModel != nil)
    }
}


