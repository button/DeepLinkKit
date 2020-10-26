// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "DeepLinkKit",
    platforms: [.iOS(.v13), .watchOS(.v6)],
    products: [
        .library(
            name: "DeepLinkKit",
            targets: ["DeepLinkKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "DeepLinkKit",
            dependencies: [],
            path: "DeepLinkKit"),
    ]
)
