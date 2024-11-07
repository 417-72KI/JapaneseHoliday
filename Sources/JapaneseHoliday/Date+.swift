import Foundation

extension Date {
    /// +1 day
    var nextDay: Date {
        let cal = Calendar(identifier: .gregorian)
        return cal.date(byAdding: .day, value: 1, to: self) ?? self
    }

    /// Set 00:00:00 in JST
    var midnight: Date {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        return cal.date(bySettingHour: 0, minute: 0, second: 0, of: self) ?? self
    }
}

extension Range<Date> {
    var distance: TimeInterval {
        upperBound.distance(to: lowerBound)
    }
}
