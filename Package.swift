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
        .library(name: "Fabric", targets: ["Fabric"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/OrzGeeker/OrzSwiftKit.git", from: "0.0.3"),
        .package(url: "https://github.com/wangzhizhou/PaperMC.git", from: "0.0.4"),
        .package(url: "https://github.com/wangzhizhou/MojangAPI.git", from: "0.0.3"),
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
            "MojangAPI",
            "Fabric",
            .product(name: "PaperMCAPI", package: "PaperMC"),
            .product(name: "Utils", package: "OrzSwiftKit"),
        ]),
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
