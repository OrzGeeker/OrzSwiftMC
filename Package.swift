// swift-tools-version:5.10
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
        .library(name: "PaperMC", targets: ["PaperMCAPI","HangarAPI"]),
        .library(name: "Fabric", targets: ["Fabric"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-openapi-generator.git", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime.git", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-openapi-urlsession.git", from: "1.0.0"),
        .package(url: "https://github.com/OrzGeeker/OrzSwiftKit.git", branch: "main"),
        .package(url: "https://github.com/wangzhizhou/ExarotonAPI.git", branch: "main"),
        .package(url: "https://github.com/Flight-School/AnyCodable.git", from: "0.6.7"),
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
            "PaperMCAPI",
            "HangarAPI",
            "Fabric",
            .product(name: "Utils", package: "OrzSwiftKit")
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
        // MARK: PaperMC
        .target(
            name: "PaperMCAPI",
            dependencies: [
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
                .product(
                    name: "OpenAPIURLSession",
                    package: "swift-openapi-urlsession"
                ),
            ],
            plugins: [
                .plugin(
                    name: "OpenAPIGenerator",
                    package: "swift-openapi-generator"
                )
            ]
        ),
        .testTarget(
            name: "PaperMCAPITests",
            dependencies: ["PaperMCAPI"]),
        .target(
            name: "HangarAPI",
            dependencies: [
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
                .product(
                    name: "OpenAPIURLSession",
                    package: "swift-openapi-urlsession"
                ),
            ],
            plugins: [
                .plugin(
                    name: "OpenAPIGenerator",
                    package: "swift-openapi-generator"
                )
            ]
        ),
        .testTarget(
            name: "HangarAPITests",
            dependencies: ["HangarAPI"]),
        // MARK: Fabric
        .target(
            name: "Fabric",
            dependencies: [.product(name: "JokerKits", package: "OrzSwiftKit")]
        ),
        .testTarget(
            name: "FabricTests",
            dependencies: ["Fabric"]
        ),
        .target(name: "Exaroton", dependencies: ["AnyCodable"]),
        .testTarget(name: "ExarotonTests", dependencies: ["Exaroton", "ExarotonAPI"]),
    ],
    swiftLanguageVersions: [.v5]
)
