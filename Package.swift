// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Samaa",
    defaultLocalization: "ar",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Samaa",
            targets: ["Samaa"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Samaa",
            dependencies: [],
            path: "Sources/Samaa",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
