// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "DeepLinkKit",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12)
    ],
    products: [
        .library(
            name: "DeepLinkKit",
            targets: ["DeepLinkKit"]
        )
    ],
    targets: [
        .target(
            name: "DeepLinkKit",
            path: "DeepLinkKit",
            exclude: ["Info.plist"],
            publicHeadersPath: "include",
            cSettings: [
                // Headers are imported by file name only, so every directory
                // holding one has to be on the search path.
                .headerSearchPath("."),
                .headerSearchPath("include/DeepLinkKit"),
                .headerSearchPath("Categories"),
                .headerSearchPath("DeepLink"),
                .headerSearchPath("Protocols"),
                .headerSearchPath("Regex"),
                .headerSearchPath("RouteMatcher")
            ]
        )
    ]
)
