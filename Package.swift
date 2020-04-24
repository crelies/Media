// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Media",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "MediaCore",
            targets: ["MediaCore"]),
        .library(
            name: "MediaSwiftUI",
            targets: ["MediaCore", "MediaSwiftUI"])
    ],
    dependencies: [],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "MediaCore",
            dependencies: []),
        .target(
            name: "MediaSwiftUI",
            dependencies: ["MediaCore"]),
        .testTarget(
            name: "MediaTests",
            dependencies: ["MediaSwiftUI"])
    ]
)

if #available(iOS 13, tvOS 13, *) {
    package.platforms = [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13)
    ]
} else {
    package.platforms = [
        .iOS("9.1"),
        .macOS(.v10_15),
        .tvOS(.v10)
    ]
}
