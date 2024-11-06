import Foundation
import Testing
@testable import JapaneseHoliday

@Test(arguments: [
    (2024, 11, 3, "文化の日"),
    (2024, 11, 4, "休日"),
    (2024, 11, 23, "勤労感謝の日"),
    (2025, 1, 1, "元日"),
    (2025, 1, 13, "成人の日"),
    (2025, 2, 11, "建国記念の日"),
    (2025, 2, 23, "天皇誕生日"),
    (2025, 2, 24, "休日"),
])
func holiday(_ year: Int, _ month: Int, _ day: Int, _ name: String) async throws {
    let holiday = try #require(Holidays[year]?[month]?[day])
    #expect(holiday.year == year)
    #expect(holiday.month == month)
    #expect(holiday.day == day)
    #expect(holiday.name == name)
}

@Test(arguments: [
    (2025, 1, 2...12),
    (2025, 1, 14...31),
    (2025, 2, 1...10),
    (2025, 2, 12...22),
    (2025, 2, 25...28),
])
func notHoliday(_ year: Int, _ month: Int, _ days: ClosedRange<Int>) async throws {
    days.forEach {
        #expect(Holidays[year]?[month]?[$0] == nil)
    }
}

@Test(arguments: [
    (1735570800, false),     // 2024/12/31
    (1735657200, true),     // 2025/1/1
    (1735743600, false),    // 2025/1/2
    (1735830000, false),    // 2025/1/3
    (1735916400, false),    // 2025/1/4
])
func holidayOfDate(_ timeInterval: TimeInterval, _ expected: Bool) async throws {
    let holiday = JapaneseHoliday.holiday(ofDate: .init(timeIntervalSince1970: timeInterval))
    #expect((holiday != nil) == expected)
}
