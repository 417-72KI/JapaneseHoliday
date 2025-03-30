import Foundation
import Testing
@testable import JapaneseHoliday

#if compiler(<6.0)
@Suite
#else
@Suite(.serialized)
#endif
struct JapaneseHolidayTests {
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
        (1735570800, false),    // 2024/12/31
        (1735657200, true),     // 2025/1/1
        (1735743600, false),    // 2025/1/2
        (1735830000, false),    // 2025/1/3
        (1735916400, false),    // 2025/1/4
    ])
    func holidayOfDate(_ timeInterval: TimeInterval, _ expected: Bool) async throws {
        let holiday = JapaneseHoliday.holiday(ofDate: .init(timeIntervalSince1970: timeInterval))
        #expect((holiday != nil) == expected)
    }

    @Test(arguments: [
        (1704034800, 1735657199, 21), // 2024/1/1 - 2024/12/31
        (1704034800, 1735657200, 22), // 2024/1/1 - 2025/1/1
        (1735657200, 1735916400, 1),  // 2025/1/1 - 2025/1/4
        (1735657200, 1738335600, 2),  // 2025/1/1 - 2025/2/1
        (1714662000, 1714921200, 4),  // 2025/5/3 - 2025/5/6
        (1735657200, 1767193199, 19), // 2025/1/1 - 2025/12/31
    ])
    func holidaysBetween(_ start: TimeInterval, _ end: TimeInterval, _ expected: Int) async throws {
        let start = Date(timeIntervalSince1970: start)
        let end = Date(timeIntervalSince1970: end)
        let holidays = JapaneseHoliday.holidays(between: start, and: end)
        #expect(holidays.count == expected)
    }

    @Test(arguments: [
        (1704034800..<1735657200, 21), // 2024/1/1 ..< 2025/1/1
        (1735657200..<1735916400, 1),  // 2025/1/1 ..< 2025/1/4
        (1735657200..<1738335600, 2),  // 2025/1/1 ..< 2025/2/1
        (1714662000..<1714921200, 3),  // 2025/5/3 ..< 2025/5/6
        (1735657200..<1767193200, 19), // 2025/1/1 ..< 2026/1/1

        (1735657300..<1735657400, 1),  // 2025/1/1 00:01:40 ..< 2025/1/1 00:03:20
    ])
    func holidaysInRange(_ range: Range<TimeInterval>, _ expected: Int) async throws {
        let range = Date(timeIntervalSince1970: range.lowerBound)..<Date(timeIntervalSince1970: range.upperBound)
        let holidays = JapaneseHoliday.holidays(in: range)
        #expect(holidays.count == expected)
    }

    @Test(arguments: [
        (1704034800...1735657200, 22), // 2024/1/1 ... 2025/1/1
        (1735657200...1735916400, 1),  // 2025/1/1 ... 2025/1/4
        (1735657200...1738335600, 2),  // 2025/1/1 ... 2025/2/1
        (1714662000...1714921200, 4),  // 2025/5/3 ... 2025/5/6
        (1735657200...1767193200, 20), // 2025/1/1 ... 2026/1/1

        (1735657300...1735657400, 1),  // 2025/1/1 00:01:40 ... 2025/1/1 00:03:20
    ])
    func holidaysInClosedRange(_ range: ClosedRange<TimeInterval>, _ expected: Int) async throws {
        let range = Date(timeIntervalSince1970: range.lowerBound)...Date(timeIntervalSince1970: range.upperBound)
        let holidays = JapaneseHoliday.holidays(in: range)
        #expect(holidays.count == expected)
    }

    @MainActor @Test
    func customHoliday() async throws {
        defer { JapaneseHoliday.customHolidays.removeAll() }
        let range = Date(timeIntervalSince1970: 1735657200)..<Date(timeIntervalSince1970: 1735916400) // 2025/1/1 - 2025/1/4
        #expect(JapaneseHoliday.customHolidays.isEmpty)
        #expect(JapaneseHoliday.holidays(in: range).count == 1)
        JapaneseHoliday.addCustomHoliday(forYear: 2025, month: 1, day: 2, named: "三が日")
        JapaneseHoliday.addCustomHoliday(forYear: 2025, month: 1, day: 3, named: "三が日")
        do {
            let holiday = try #require(JapaneseHoliday.customHolidays[2025]?[1]?[2])
            #expect(holiday.year == 2025)
            #expect(holiday.month == 1)
            #expect(holiday.day == 2)
            #expect(holiday.name == "三が日")
        }
        do {
            let holiday = try #require(JapaneseHoliday.customHolidays[2025]?[1]?[3])
            #expect(holiday.year == 2025)
            #expect(holiday.month == 1)
            #expect(holiday.day == 3)
            #expect(holiday.name == "三が日")
        }
        #expect(JapaneseHoliday.holidays(in: range).count == 3)
    }

    @MainActor @Test
    func customHolidayForEveryYears() async throws {
        defer { JapaneseHoliday.customHolidays.removeAll() }
        #expect(JapaneseHoliday.customHolidays.isEmpty)

        let cal = Calendar(identifier: .gregorian)
        let years = (1955...2015)
        let yearsForNewYearsSunday = [1978, 1984, 1989, 1995, 2006, 2012]
        years.forEach { year in
            let start = DateComponents(calendar: cal, year: year, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0).date!
            let end = DateComponents(calendar: cal, year: year, month: 1, day: 4, hour: 0, minute: 0, second: 0, nanosecond: 0).date!
            if yearsForNewYearsSunday.contains(year) {
                #expect(JapaneseHoliday.holidays(in: start..<end).count == 2, "year: \(year)")
            } else {
                #expect(JapaneseHoliday.holidays(in: start..<end).count == 1, "year: \(year)")
            }
        }
        JapaneseHoliday.addCustomHoliday(forMonth: 1, day: 2, named: "三が日")
        JapaneseHoliday.addCustomHoliday(forMonth: 1, day: 3, named: "三が日")
        try years.forEach { year in
            do {
                let holiday = try #require(JapaneseHoliday.customHolidays[year]?[1]?[2])
                #expect(holiday.year == year)
                #expect(holiday.month == 1)
                #expect(holiday.day == 2)
                #expect(holiday.name == "三が日")
            }
            do {
                let holiday = try #require(JapaneseHoliday.customHolidays[year]?[1]?[3])
                #expect(holiday.year == year)
                #expect(holiday.month == 1)
                #expect(holiday.day == 3)
                #expect(holiday.name == "三が日")
            }
        }
        years.forEach { year in
            let start = DateComponents(calendar: cal, year: year, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0).date!
            let end = DateComponents(calendar: cal, year: year, month: 1, day: 4, hour: 0, minute: 0, second: 0, nanosecond: 0).date!
            #expect(JapaneseHoliday.holidays(in: start..<end).count == 3)
        }
    }
}
