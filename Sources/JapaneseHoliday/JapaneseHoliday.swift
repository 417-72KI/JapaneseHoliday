import Foundation
import Common

public enum JapaneseHoliday {
}

public extension JapaneseHoliday {
    static func holiday(year: Int, month: Int, day: Int) -> Holiday? {
        Holidays[String(format: "%04d-%02d-%02d", year, month, day)]
    }

    static func holiday(ofDate date: Date) -> Holiday? {
        let (year, month, day) = ymdComponents(from: date)
        return holiday(year: year, month: month, day: day)
    }

    static func holidays(between start: Date, and end: Date) -> [Holiday] {
        precondition(start <= end)
        let start = ymdComponents(from: start)
        let end = ymdComponents(from: end)
        return (start.year...end.year).flatMap { year in
            let monthRange = switch year {
            case start.year: (start.month...12)
            case end.year: (1...end.month)
            default: (1...12)
            }
            return monthRange.flatMap { month in
                let dayRange = switch month {
                case start.month where year == start.year: (start.day...31)
                case end.month where year == end.year: (1...end.day)
                default: 1...31
                }
                return dayRange.compactMap { day in
                    Holidays[String(format: "%04d-%02d-%02d", year, month, day)]
                }
            }
        }
    }
}

private extension JapaneseHoliday {
    static let calendar = Calendar(identifier: .gregorian)
}

private extension JapaneseHoliday {
    static func ymdComponents(from date: Date) -> (year: Int, month: Int, day: Int) {
        let comps = calendar.dateComponents([.year, .month, .day], from: date)
        return (comps.year!, comps.month!, comps.day!)
    }
}
