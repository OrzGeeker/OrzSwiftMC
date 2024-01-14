// swift-tools-version:5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OrzMC",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "orzmc", targets: ["OrzMC"]),
        .library(name: "Game", targets: ["Game"]),
        .library(name: "JokerKits", targets: ["JokerKits"]),
        .library(name: "Mojang", targets: ["Mojang"]),
        .library(name: "PaperMC", targets: ["PaperMC"]),
        .library(name: "Fabric", targets: ["Fabric"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/vapor/console-kit.git", .upToNextMajor(from: "4.4.0")),
        .package(url: "https://github.com/apple/swift-crypto.git", .upToNextMajor(from: "2.6.0")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.1")),
        .package(url: "https://github.com/apple/swift-openapi-generator.git", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime.git", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-openapi-urlsession.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
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
        ),
        .target(
            name: "Mojang",
            dependencies: ["JokerKits"]
        ),
        .testTarget(
            name: "MojangTests",
            dependencies: ["Mojang"]
        ),
        .target(name: "Game", dependencies: [
            "Mojang",
            "PaperMC",
            "Fabric"
        ]),
        .executableTarget(
            name: "OrzMC",
            dependencies: ["Game"]
        ),
        .testTarget(
            name: "OrzMCTests",
            dependencies: ["OrzMC"]
        ),
        .target(
            name: "PaperMC",
            dependencies: [
                "JokerKits",
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
            name: "PaperMCTests",
            dependencies: ["PaperMC"]
        ),
        .target(
            name: "Fabric",
            dependencies: ["JokerKits"]
        ),
        .testTarget(
            name: "FabricTests",
            dependencies: ["Fabric"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
