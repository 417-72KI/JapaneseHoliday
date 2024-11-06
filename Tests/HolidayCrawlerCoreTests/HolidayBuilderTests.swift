import Testing
@testable import HolidayCrawlerCore
import Common

@Suite
struct HolidayBuilderTests {
    @Test func build() async throws {
        let holidays = [
            Holiday(year: 2024, month: 11, day: 3, name: "文化の日"),
            Holiday(year: 2024, month: 11, day: 4, name: "休日"),
            Holiday(year: 2024, month: 11, day: 23, name: "勤労感謝の日"),
            Holiday(year: 2025, month: 1, day: 1, name: "元日"),
            Holiday(year: 2025, month: 1, day: 13, name: "成人の日"),
        ]
        let source = HolidayBuilder.build(holidays).formatted().description
        let expected = """
            import Foundation
            import Common
            
            let Holidays: [Int: [Int: [Int: Holiday]]] = [
                2024: [
                    11: [
                        3: Holiday(year: 2024, month: 11, day: 3, name: "文化の日"),
                        4: Holiday(year: 2024, month: 11, day: 4, name: "休日"),
                        23: Holiday(year: 2024, month: 11, day: 23, name: "勤労感謝の日")
                    ]
                ],
                2025: [
                    1: [
                        1: Holiday(year: 2025, month: 1, day: 1, name: "元日"),
                        13: Holiday(year: 2025, month: 1, day: 13, name: "成人の日")
                    ]
                ]
            ]
            """
        let sourceLines = source.split(separator: "\n")
        let expectedLines = expected.split(separator: "\n")

        #expect(sourceLines.count == expectedLines.count)
        zip(sourceLines, expectedLines).forEach {
            #expect($0 == $1)
        }
    }

    @Test func build_empty() async throws {
        let source = HolidayBuilder.build([]).formatted().description
        let expected = """
            import Foundation
            import Common
            
            let Holidays: [Int: [Int: [Int: Holiday]]] = [:]
            """
        let sourceLines = source.split(separator: "\n")
        let expectedLines = expected.split(separator: "\n")

        #expect(sourceLines.count == expectedLines.count)
        zip(sourceLines, expectedLines).forEach {
            #expect($0 == $1)
        }
    }
}
