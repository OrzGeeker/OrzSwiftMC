// swift-tools-version:5.5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OrzMC",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "orzmc", targets: ["OrzMC"]),
        .library(name: "JokerKits", targets: ["JokerKits"]),
        .library(name: "Mojang", targets: ["Mojang"]),
        .library(name: "PaperMC", targets: ["PaperMC"]),
        .library(name: "Fabric", targets: ["Fabric"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/vapor/console-kit.git", from: "4.4.0"),
        .package(url: "https://github.com/apple/swift-crypto.git", "1.0.0" ..< "3.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.6.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "JokerKits",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto", condition: .when(platforms: [.linux])),
                "Alamofire",
                .product(name: "ConsoleKit", package: "console-kit"),
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
        
        .executableTarget(
            name: "OrzMC",
            dependencies: [
                "Mojang",
                "PaperMC",
                "Fabric"
            ]
        ),
        .testTarget(
            name: "OrzMCTests",
            dependencies: ["OrzMC"]
        ),
        
        .target(
            name: "PaperMC",
            dependencies: ["JokerKits"]
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
