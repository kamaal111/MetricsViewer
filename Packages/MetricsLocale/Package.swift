// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MetricsLocale",
    defaultLocalization: "en",
    products: [
        .library(
            name: "MetricsLocale",
            targets: ["MetricsLocale"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MetricsLocale",
            dependencies: [],
            resources: [.process("Resources")]),
        .testTarget(
            name: "MetricsLocaleTests",
            dependencies: ["MetricsLocale"]),
    ]
)
