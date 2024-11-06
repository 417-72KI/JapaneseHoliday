import Foundation
import Testing
@testable import JapaneseHoliday

@Test(arguments: [
    ("2024-11-03", 2024, 11, 3, "文化の日"),
    ("2024-11-04", 2024, 11, 4, "休日"),
    ("2024-11-23", 2024, 11, 23, "勤労感謝の日"),
])
func holiday(_ ymd: String, _ year: Int, _ month: Int, _ day: Int, _ name: String) async throws {
    let holiday = try #require(Holidays[ymd])
    #expect(holiday.year == year)
    #expect(holiday.month == month)
    #expect(holiday.day == day)
    #expect(holiday.name == name)
}

@Test(arguments: [
    "2024-01-02"
])
func notHoliday(_ ymd: String) async throws {
    #expect(Holidays[ymd] == nil)
}

@Test(arguments: [
    (1704034800, true),  // 2024/1/1
    (1704121200, false), // 2024/1/2
])
func holidayOfDate(_ timeInterval: TimeInterval, _ expected: Bool) async throws {
    let holiday = JapaneseHoliday.holiday(ofDate: .init(timeIntervalSince1970: timeInterval))
    #expect((holiday != nil) == expected)
}
