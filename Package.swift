// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ZamzamKit",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "ZamzamCore",
            targets: ["ZamzamCore"]
        ),
        .library(
            name: "ZamzamUI",
            targets: ["ZamzamUI"]
        ),
        .library(
            name: "ZamzamNotification",
            targets: ["ZamzamNotification"]
        ),
        .library(
            name: "ZamzamLocation",
            targets: ["ZamzamLocation"]
        )
    ],
    targets: [
        .target(
            name: "ZamzamCore"
        ),
        .testTarget(
            name: "ZamzamCoreTests",
            dependencies: ["ZamzamCore"],
            exclude: ["Network/Certificates"],
            resources: [.process("Resources")]
        ),
        .target(
            name: "ZamzamUI",
            dependencies: ["ZamzamCore"]
        ),
        .testTarget(
            name: "ZamzamUITests",
            dependencies: ["ZamzamUI"]
        ),
        .target(
            name: "ZamzamNotification",
            dependencies: ["ZamzamCore"]
        ),
        .testTarget(
            name: "ZamzamNotificationTests",
            dependencies: ["ZamzamNotification"]
        ),
        .target(
            name: "ZamzamLocation",
            dependencies: ["ZamzamCore"]
        ),
        .testTarget(
            name: "ZamzamLocationTests",
            dependencies: ["ZamzamLocation"]
        )
    ]
)
