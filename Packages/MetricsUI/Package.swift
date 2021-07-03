// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MetricsUI",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .library(
            name: "MetricsUI",
            targets: ["MetricsUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kamaal111/SalmonUI.git", from: "4.1.0"),
        .package(path: "../MetricsLocale"),
    ],
    targets: [
        .target(
            name: "MetricsUI",
            dependencies: [
                "SalmonUI",
                "MetricsLocale",
            ]),
        .testTarget(
            name: "MetricsUITests",
            dependencies: ["MetricsUI"]),
    ]
)
