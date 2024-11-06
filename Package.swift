// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let isCrawling = true

let package = Package(
    name: "JapaneseHoliday",
    platforms: [.macOS(.v14), .iOS(.v16)],
    products: [
        .library(name: "JapaneseHoliday", targets: ["JapaneseHoliday"]),
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
                dependencies: [
                    "Common",
                    .product(name: "SwiftSyntax", package: "swift-syntax"),
                    .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                    .product(name: "SwiftParser", package: "swift-syntax"),
                ]
            ),
        ]
    )
}
