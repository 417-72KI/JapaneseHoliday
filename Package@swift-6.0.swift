// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let isCrawling = false

let isApplePlatform: Bool = {
    #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    return true
    #else
    return false
    #endif
}()

let package = Package(
    name: "JapaneseHoliday",
    platforms: [.macOS(.v14), .iOS(.v16), .tvOS(.v16), .watchOS(.v9)],
    products: [
        .library(
            name: "JapaneseHoliday",
            targets: ["JapaneseHoliday", "Common"]
        ),
    ],
    targets: [
        .target(
            name: "JapaneseHoliday",
            dependencies: ["Common"]
        ),
        .target(name: "Common"),
        .testTarget(
            name: "JapaneseHolidayTests",
            dependencies: ["JapaneseHoliday"]
        ),
    ],
    swiftLanguageModes: [.v6]
)

if isCrawling {
    package.dependencies.append(contentsOf: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", exact: "600.0.1"),
    ])
    package.products.append(contentsOf: [
        .executable(name: "holiday-crawler", targets: ["HolidayCrawler"]),
    ])
    package.targets.append(
        contentsOf: [
            .executableTarget(
                name: "HolidayCrawler",
                dependencies: ["HolidayCrawlerCore"]
            ),
            .target(
                name: "HolidayCrawlerCore",
                dependencies: [
                    "Common",
                    .product(name: "SwiftSyntax", package: "swift-syntax"),
                               .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                    .product(name: "SwiftParser", package: "swift-syntax"),
                ]
            ),
            .testTarget(
                name: "HolidayCrawlerCoreTests",
                dependencies: ["HolidayCrawlerCore"]
            )
        ]
    )
    if isApplePlatform {
        package.dependencies.append(contentsOf: [
            .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins.git", from: "0.57.0"),
        ])
        package.targets.forEach {
            $0.dependencies.append(contentsOf: [
                .product(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
            ])
        }
    }
}

// MARK: - Upcoming feature flags for Swift 7
package.targets.forEach {
    $0.swiftSettings = [
        .existentialAny,
    ]
}

// ref: https://github.com/treastrain/swift-upcomingfeatureflags-cheatsheet
private extension SwiftSetting {
    static let existentialAny: Self = .enableUpcomingFeature("ExistentialAny")                                // SE-0335, Swift 5.6,  SwiftPM 5.8+
}
