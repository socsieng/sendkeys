// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "sendkeys",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-format", from: "600.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .executableTarget(
            name: "sendkeys",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "SendKeysLib",
            ]),
        .target(
            name: "SendKeysLib",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "SendKeysTests",
            dependencies: ["sendkeys", "SendKeysLib"]),
    ]
)
