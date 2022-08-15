//
//  DateFormatterHelper.swift
//  XWeather
//
//  Created by teenloong on 2022/5/22.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

extension DateFormatter {
    static func formatter(_ format: String, localized: Bool = false) -> DateFormatter {
        let formatter = DateFormatter()
        if localized {
            formatter.locale = .current
            formatter.setLocalizedDateFormatFromTemplate(format)
        }else {
            formatter.locale = Locale(identifier: "en_US_POSIX") // fixes nil if device time in 24 hour format
            formatter.dateFormat = format
        }
        return formatter
    }
    
    static func chineseFormatter(_ style: DateFormatter.Style) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.init(identifier: .chinese)
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateStyle = style
        return formatter
    }
}

/*
 https://stackoverflow.com/questions/35700281/date-format-in-swift
 Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
 09/12/2018                        --> MM/dd/yyyy
 09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
 Sep 12, 2:11 PM                   --> MMM d, h:mm a
 September 2018                    --> MMMM yyyy
 Sep 12, 2018                      --> MMM d, yyyy
 Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
 2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
 12.09.18                          --> dd.MM.yy
 10:41:02.112                      --> HH:mm:ss.SSS
 Here are alternatives:

 era: G (AD), GGGG (Anno Domini)
 year: y (2018), yy (18), yyyy (2018)
 month: M, MM, MMM, MMMM, MMMMM
 day of month: d, dd
 day name of week: E, EEEE, EEEEE, EEEEEE
 */

extension Date {
    init?(formatterString: String, dateString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = formatterString
        if let date = formatter.date(from: dateString) {
            self = date
        } else {
            return nil
        }
    }
    
    func formatString(_ format: String, localized: Bool = false) -> String {
        DateFormatter.formatter(format, localized: localized).string(from: self)
    }
    
    func chineseFormatString(_ style: DateFormatter.Style) -> String {
        DateFormatter.chineseFormatter(style).string(from: self)
    }
    
    func chineseFormatMMddString() -> String {
        let string = DateFormatter.chineseFormatter(.medium).string(from: self)
        let indexStart = string.index(string.startIndex, offsetBy: 5)
        return String(string[indexStart..<string.endIndex])
    }
    
    func relativeDateTimeString(to date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        return formatter.localizedString(for: self, relativeTo: date)
    }
    
    func relativeDateString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormat = DateFormatter()
        dateFormat.locale = .current
        dateFormat.dateStyle = dateStyle
        dateFormat.timeStyle = timeStyle
        dateFormat.doesRelativeDateFormatting = true

        return dateFormat.string(from: self)
    }
}
