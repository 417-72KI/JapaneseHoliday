import Foundation
import Testing
@testable import JapaneseHoliday

@Test(arguments: [
    ("2024-01-01", true),
    ("2024-01-02", false),
])
func holidays(_ ymd: String, _ expected: Bool) async throws {
    #expect((holidays[ymd] != nil) == expected)
}

@Test(arguments: [
    (1704034800, true),  // 2024/1/1
    (1704121200, false), // 2024/1/2
])
func holiday(_ timeInterval: TimeInterval, _ expected: Bool) async throws {
    let holiday = JapaneseHoliday.holiday(ofDate: .init(timeIntervalSince1970: timeInterval))
    #expect((holiday != nil) == expected)
}
