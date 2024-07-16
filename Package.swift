// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OrzMC",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "orzmc", targets: ["OrzMC"]),
        .library(name: "Game", targets: ["Game"]),
        .library(name: "Mojang", targets: ["Mojang"]),
        .library(name: "Fabric", targets: ["Fabric"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/OrzGeeker/OrzSwiftKit.git", from: "0.0.3"),
        .package(url: "https://github.com/wangzhizhou/PaperMC.git", from: "0.0.1"),
    ],
    targets: [
        // MARK: Command Line executable
        .executableTarget(
            name: "OrzMC",
            dependencies: ["Game"]
        ),
        .testTarget(
            name: "OrzMCTests",
            dependencies: ["OrzMC"]
        ),
        // MARK: Game Logic Capsule
        .target(name: "Game", dependencies: [
            "Mojang",
            "Fabric",
            .product(name: "Utils", package: "OrzSwiftKit"),
            .product(name: "DownloadAPI", package: "PaperMC")
        ]),
        // MARK: Mojang Offical
        .target(
            name: "Mojang",
            dependencies: [.product(name: "JokerKits", package: "OrzSwiftKit")]
        ),
        .testTarget(
            name: "MojangTests",
            dependencies: ["Mojang"]
        ),
        // MARK: Fabric
        .target(
            name: "Fabric",
            dependencies: [.product(name: "JokerKits", package: "OrzSwiftKit")]
        ),
        .testTarget(
            name: "FabricTests",
            dependencies: ["Fabric"]
        ),
    ]
)
