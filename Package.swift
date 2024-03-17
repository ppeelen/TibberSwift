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
    targets: [
        .target(
            name: "TibberSwift",
            resources: [
                .process("Queries")
            ]),
        .testTarget(
            name: "TibberSwiftTests",
            dependencies: ["TibberSwift"],
            resources: [
                .copy("json")
            ]
        )
    ]
)
