// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MetricsNetworker",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .library(
            name: "MetricsNetworker",
            targets: ["MetricsNetworker"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kamaal111/XiphiasNet.git", from: "5.0.0"),
        .package(url: "https://github.com/kamaal111/ShrimpExtensions.git", from: "2.1.0")
    ],
    targets: [
        .target(
            name: "MetricsNetworker",
            dependencies: ["XiphiasNet", "ShrimpExtensions"]),
        .testTarget(
            name: "MetricsNetworkerTests",
            dependencies: ["MetricsNetworker"]),
    ]
)
