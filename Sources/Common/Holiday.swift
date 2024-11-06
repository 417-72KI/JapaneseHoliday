import Foundation

public struct Holiday: Sendable, Codable {
    public var year: Int
    public var month: Int
    public var day: Int
    public var name: String

    package init(year: Int, month: Int, day: Int, name: String) {
        self.year = year
        self.month = month
        self.day = day
        self.name = name
    }
}

package extension Holiday {
    var date: String {
        String(format: "%04d-%02d-%02d", year, month, day)
    }
}

package extension Holiday {
    static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = .init(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
}

package extension Holiday {
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }

    static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }
}
