import Foundation
import Common

/// A main utility for calculating Japanese holidays.
public enum JapaneseHoliday {
}

public extension JapaneseHoliday {
    /// Returns a holiday corresponding to the date, or nil if it is not a holiday.
    static func holiday(year: Int, month: Int, day: Int) -> Holiday? {
        Holidays[year]?[month]?[day]
    }

    /// Returns a holiday corresponding to the date, or nil if it is not a holiday.
    static func holiday(ofDate date: Date) -> Holiday? {
        let (year, month, day) = ymdComponents(from: date)
        return holiday(year: year, month: month, day: day)
    }

    /// Returns an array of holidays including in the range.
    static func holidays(in range: Range<Date>) -> [Holiday] {
        holidays(
            between: range.lowerBound,
            and: range.upperBound.advanced(by: max(range.distance, -86400))
        )
    }

    /// Returns an array of holidays including in the range.
    static func holidays(in range: ClosedRange<Date>) -> [Holiday] {
        holidays(between: range.lowerBound, and: range.upperBound)
    }

    /// Returns an array of holidays including in the range from `start` to `end`.
    static func holidays(between start: Date, and end: Date) -> [Holiday] {
        precondition(start <= end)
        var date = start.midnight
        var holidays = [Holiday]()
        while date <= end {
            defer { date = date.nextDay }
            let (year, month, day) = ymdComponents(from: date)
            if let holiday = holiday(year: year, month: month, day: day) {
                holidays.append(holiday)
            }
        }
        return holidays
    }
}

private extension JapaneseHoliday {
    static let calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        return cal
    }()
}

private extension JapaneseHoliday {
    static func ymdComponents(from date: Date) -> (year: Int, month: Int, day: Int) {
        let comps = calendar.dateComponents([.year, .month, .day], from: date)
        return (comps.year!, comps.month!, comps.day!)
    }
}
