// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swift-ISO8601-DurationParser",
    products: [
        .library(
            name: "Swift-ISO8601-DurationParser",
            targets: ["Swift-ISO8601-DurationParser"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Swift-ISO8601-DurationParser",
            dependencies: []
        ),
        .testTarget(
            name: "Swift-ISO8601-DurationParserTests",
            dependencies: ["Swift-ISO8601-DurationParser"]
        ),
    ]
)
