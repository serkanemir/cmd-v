// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CommandV",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "command-v", targets: ["CommandV"])
    ],
    targets: [
        .executableTarget(
            name: "CommandV"
        ),
        .testTarget(
            name: "CommandVTests",
            dependencies: ["CommandV"]
        )
    ]
)
