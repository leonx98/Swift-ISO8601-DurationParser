// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swift-ISO8601-DurationParser",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Swift-ISO8601-DurationParser",
            targets: ["Swift-ISO8601-DurationParser"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Swift-ISO8601-DurationParser",
            dependencies: []),
        .testTarget(
            name: "Swift-ISO8601-DurationParserTests",
            dependencies: ["Swift-ISO8601-DurationParser"]),
    ]
)
