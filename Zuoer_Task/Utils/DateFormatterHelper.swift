//
//  DateFormatterHelper.swift
//  Zuoer_Task
//
//  Created by Rishop Babu on 14/05/26.
//

import Foundation

struct DateFormatterHelper {

    private static let iso8601Formatter: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "h:mm a"
        return f
    }()

    private static let fullFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "dd/MM/yyyy, h:mm a"
        return f
    }()

    static func format(_ iso8601String: String) -> String {
        guard let date = iso8601Formatter.date(from: iso8601String) else {
            return iso8601String
        }
        let calendar = Calendar.current
        let time = timeFormatter.string(from: date)

        if calendar.isDateInToday(date) {
            return "Today, \(time)"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow, \(time)"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday, \(time)"
        } else {
            return fullFormatter.string(from: date)
        }
    }
}
