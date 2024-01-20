// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PromoveIOS",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections", from: "1.0.3"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture",  from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/swiftui-navigation", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        
        .target(
            name: "AppFeature",
            dependencies: [
                "Models",
                "CategoryFeature",
                .tca, .swiftUINavigation,.swiftCollections
            ]
        ),
        .target(
            name: "CategoryFeature",
            dependencies: [
                "Models",
                "APIClient",
                .tca, .swiftUINavigation,.swiftCollections
            ]
        ),
        .target(
            name: "APIClient",
            dependencies: [
                "Models",
                .tca, .xctest,
            ]
        ),
        .target(
            name: "Models",
            dependencies: [
                
            ]
        ),
        
        
            .testTarget(
                name: "AppFeatureTests",
                dependencies: ["AppFeature"]),
    ]
)

private extension Target.Dependency {
    static let tca: Self = .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
    static let tcaDependencies: Self = .product(name: "Dependencies", package: "swift-composable-architecture")
    static let swiftCollections: Self = .product(name: "Collections", package: "swift-collections")
    static let swiftUINavigation: Self = .product(name: "SwiftUINavigation", package: "swiftui-navigation")
    static let xctest: Self = .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay")
}
