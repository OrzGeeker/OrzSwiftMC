// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OrzMC",
    platforms: [
        .macOS(.v13),
        .iOS(.v13),
        .tvOS(.v13)
    ],
    products: [
        .executable(name: "orzmc", targets: ["OrzMC"]),
        .library(name: "Game", targets: ["Game"]),
        .library(name: "JokerKits", targets: ["JokerKits"]),
        .library(name: "Mojang", targets: ["Mojang"]),
        .library(name: "PaperMC", targets: ["PaperMCAPI","HangarAPI"]),
        .library(name: "Fabric", targets: ["Fabric"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/vapor/console-kit.git", .upToNextMajor(from: "4.4.0")),
        .package(url: "https://github.com/apple/swift-crypto.git", .upToNextMajor(from: "2.6.0")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.8.1")),
        .package(url: "https://github.com/apple/swift-openapi-generator.git", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime.git", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-openapi-urlsession.git", from: "1.0.0"),
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
            "Fabric"
        ]),
        // MARK: Mojang Offical
        .target(
            name: "Mojang",
            dependencies: ["JokerKits"]
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
            dependencies: ["JokerKits"]
        ),
        .testTarget(
            name: "FabricTests",
            dependencies: ["Fabric"]
        ),
        // MARK: Utils
        .target(
            name: "JokerKits",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto", condition: .when(platforms: [.linux])),
                "Alamofire",
                .product(name: "ConsoleKit", package: "console-kit")
            ]
        ),
        .testTarget(
            name: "JokerKitsTests",
            dependencies: ["JokerKits"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
