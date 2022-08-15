//
//  CalendarHelper.swift
//  XWeather
//
//  Created by teenloong on 2022/8/13.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation

extension Calendar.Identifier: CaseIterable {
    public static var allCases: [Calendar.Identifier] {
        [.buddhist, .chinese, .coptic, .ethiopicAmeteAlem, .ethiopicAmeteMihret ,.gregorian, .hebrew, .indian, .islamic, .islamicCivil, .islamicTabular, .islamicUmmAlQura, .iso8601, .japanese, .persian, .republicOfChina]
    }
}

extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)

        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }

        return dates
    }
    
    func generateSecondsRefreshTimerDate(date: Date) -> Date {
        let now = date
        let dateComponets = self.dateComponents(in: .current, from: now)
        let hours = dateComponets.hour ?? 0
        let minutes = dateComponets.minute ?? 0
        let seconds = dateComponets.second ?? 0
        let components = DateComponents(hour: -hours, minute: -minutes, second: -seconds)
        let timerDate = self.date(byAdding: components, to: now)!
        return timerDate
    }
    
    func nextDay(for date: Date) -> Date {
        dateInterval(of: .day, for: date)!.end
    }
    
    func nextHour(for date: Date) -> Date {
        dateInterval(of: .hour, for: date)!.end
    }
    
    func nextMinute(for date: Date) -> Date {
        dateInterval(of: .minute, for: date)!.end
    }
    
    func weekDates(date: Date) -> [Date] {
        guard let interval = dateInterval(of: .weekOfYear, for: date) else { return [] }

        return generateDates(inside: interval , matching: DateComponents(hour: 0, minute: 0, second: 0))
    }
    
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day!
    }
}
