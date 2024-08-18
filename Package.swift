// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "link-routing",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "LinkRouting",
            targets: ["LinkRouting"]
        ),
    ],
    targets: [
        .target(
            name: "LinkRouting",
            path: "Sources"
        ),
        .testTarget(
            name: "LinkRoutingTests",
            dependencies: ["LinkRouting"],
            path: "Tests"
        )
    ],
    swiftLanguageModes: [.v6]
)
