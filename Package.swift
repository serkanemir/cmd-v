// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "cmd-v",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "cmd-v", targets: ["CmdV"])
    ],
    targets: [
        .executableTarget(
            name: "CmdV"
        ),
        .testTarget(
            name: "CmdVTests",
            dependencies: ["CmdV"]
        )
    ]
)
