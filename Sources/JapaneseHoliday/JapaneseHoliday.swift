import Foundation
import Common

public enum JapaneseHoliday {
}

public extension JapaneseHoliday {
    static func holiday(ofDate date: Date) -> Holiday? {
        let comps = calendar.dateComponents([.year, .month, .day], from: date)
        let year = comps.year!
        let month = comps.month!
        let day = comps.day!
        return holidays[String(format: "%04d-%02d-%02d", year, month, day)]
    }
}

private extension JapaneseHoliday {
    static let calendar = Calendar(identifier: .gregorian)
}
