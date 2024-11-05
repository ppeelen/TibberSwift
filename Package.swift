// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TibberSwift",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .tvOS(.v15),
        .watchOS(.v7)
    ],
    products: [
        .library(
            name: "TibberSwift",
            targets: ["TibberSwift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.1"),
    ],
    targets: [
        .target(
            name: "TibberSwift",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
            ],
            resources: [
                .process("Queries")
            ]),
        .testTarget(
            name: "TibberSwiftTests",
            dependencies: ["TibberSwift"],
            resources: [
                .copy("json"),
                .copy("Operations")
            ]
        )
    ]
)
