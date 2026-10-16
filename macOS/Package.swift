// swift-tools-version: 6.0
import Foundation
import PackageDescription

let repositoryRoot = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent().deletingLastPathComponent()
let rustLibraryPath = repositoryRoot.appendingPathComponent(".build/rust/debug").path

let package = Package(
    name: "Ember",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "Ember", targets: ["Ember"]),
        .library(name: "EmberKit", targets: ["EmberKit"])
    ],
    targets: [
        .systemLibrary(name: "CEmberCore"),
        .target(
            name: "EmberKit",
            dependencies: ["CEmberCore"],
            linkerSettings: [
                .unsafeFlags(["-L", rustLibraryPath]),
                .linkedLibrary("ember_ffi"),
                .linkedLibrary("iconv"),
                .linkedFramework("Security"),
                .linkedFramework("SystemConfiguration")
            ]
        ),
        .executableTarget(name: "Ember", dependencies: ["EmberKit"]),
        .testTarget(name: "EmberKitTests", dependencies: ["EmberKit"])
    ]
)
