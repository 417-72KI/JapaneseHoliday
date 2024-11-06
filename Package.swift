// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let isCrawling = true

let package = Package(
    name: "JapaneseHoliday",
    platforms: [.macOS(.v14), .iOS(.v16)],
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
    ]
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
}

// MARK: - Upcoming feature flags for Swift 6
package.targets.forEach {
    $0.swiftSettings = [
        .forwardTrailingClosures,
        .existentialAny,
        .bareSlashRegexLiterals,
        .conciseMagicFile,
        .importObjcForwardDeclarations,
        .disableOutwardActorInference,
        .deprecateApplicationMain,
        .isolatedDefaultValues,
        .globalConcurrency,
    ]
}

// ref: https://github.com/treastrain/swift-upcomingfeatureflags-cheatsheet
private extension SwiftSetting {
    static let forwardTrailingClosures: Self = .enableUpcomingFeature("ForwardTrailingClosures")              // SE-0286, Swift 5.3,  SwiftPM 5.8+
    static let existentialAny: Self = .enableUpcomingFeature("ExistentialAny")                                // SE-0335, Swift 5.6,  SwiftPM 5.8+
    static let bareSlashRegexLiterals: Self = .enableUpcomingFeature("BareSlashRegexLiterals")                // SE-0354, Swift 5.7,  SwiftPM 5.8+
    static let conciseMagicFile: Self = .enableUpcomingFeature("ConciseMagicFile")                            // SE-0274, Swift 5.8,  SwiftPM 5.8+
    static let importObjcForwardDeclarations: Self = .enableUpcomingFeature("ImportObjcForwardDeclarations")  // SE-0384, Swift 5.9,  SwiftPM 5.9+
    static let disableOutwardActorInference: Self = .enableUpcomingFeature("DisableOutwardActorInference")    // SE-0401, Swift 5.9,  SwiftPM 5.9+
    static let deprecateApplicationMain: Self = .enableUpcomingFeature("DeprecateApplicationMain")            // SE-0383, Swift 5.10, SwiftPM 5.10+
    static let isolatedDefaultValues: Self = .enableUpcomingFeature("IsolatedDefaultValues")                  // SE-0411, Swift 5.10, SwiftPM 5.10+
    static let globalConcurrency: Self = .enableUpcomingFeature("GlobalConcurrency")                          // SE-0412, Swift 5.10, SwiftPM 5.10+
}

// MARK: - Enabling Complete Concurrency Checking for Swift 6
// ref: https://www.swift.org/documentation/concurrency/
package.targets.forEach {
    var settings = $0.swiftSettings ?? []
    settings.append(.enableExperimentalFeature("StrictConcurrency"))
    $0.swiftSettings = settings
}
