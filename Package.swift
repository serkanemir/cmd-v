// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "cmd-v",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "cmd-v", targets: ["CommandV"])
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
