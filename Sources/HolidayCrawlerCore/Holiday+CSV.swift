import Foundation
import Common

package extension Holiday {
    init(csv: String) throws {
        let strs = csv.split(separator: ",").map(String.init)
        guard strs.count == 2 else {
            throw ConvertError.invalidCSV(csv)
        }
        let dateFormatter = Self.dateFormatter
        guard let date = dateFormatter.date(from: strs[0]) else {
            throw ConvertError.invalidFormat(dateFormatter, strs[0])
        }
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = dateFormatter.timeZone
        let year = cal.component(.year, from: date)
        let month = cal.component(.month, from: date)
        let day = cal.component(.day, from: date)
        self.init(year: year, month: month, day: day, name: strs[1])
    }

    init(csv: any StringProtocol) throws {
        try self.init(csv: String(csv))
    }
}

private extension Holiday {
    enum ConvertError: LocalizedError {
        case invalidCSV(String)
        case invalidFormat(DateFormatter, String)
    }
}
