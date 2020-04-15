//
//  CalendarUtil.swift
//  CalendarMaker
//
//  Created by Seonghyun on 2020/04/15.
//  Copyright © 2020 Poodlesoft. All rights reserved.
//

import Foundation
import UIKit

internal class CalendarUtil {
    
    /// You can get the day of the specific date
    ///
    /// - Parameter year: year
    /// - Parameter month: month
    /// - Parameter day: date
    ///
    /// - Returns: String related to day Ex) Sun, Sunday, S
    /// - note: It accepts day whici is over the last day of the month.
    ///         Ex) If you insert 2019/2/40, you get the information of 3/12(40days after 2/1)
    static func weekday(year: UInt, month: Month, day: Int) -> (String?, UInt)? {
        let calendar = Calendar(identifier: .gregorian)
        
        guard let targetDate: Date = {
            let comps = DateComponents(calendar:calendar, year: Int(year), month: month.rawValue, day: day)
            return comps.date
            }() else { return nil }
        
        let day = Calendar.current.component(.weekday, from: targetDate) - 1
        
        return (Calendar.current.shortWeekdaySymbols[day], UInt(day + 1)) // ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        //    return Calendar.current.standaloneWeekdaySymbols[day] // ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday",
        //    return Calendar.current.veryShortWeekdaySymbols[day] // ["S", "M", "T", "W", "T", "F", "S"]
    }
    
    /// Should return between 4 and 6
    static func numberOfWeeks(year: UInt, month: Month, startsWithMonday: Bool = false) -> Int? {
        guard  1...12 ~= month.rawValue else { return nil }
        
        let targetFirstDay = UInt(startsWithMonday ? 2 : 1) // 2: Mon, 1: Sun
        guard let firstMonSun = (1...7).first(where: { weekday(year: year, month: month, day: $0)?.1 == targetFirstDay }) else {
            return nil
        }
        
        let lastDay = month.days(year: year)
        let targetLastDay = UInt(startsWithMonday ? 1 : 7) // 1: Sun, 7: Sat
        guard let lastSatMon = ((lastDay - 6)...lastDay).first(where: { weekday(year: year, month: month, day: $0)?.1 == targetLastDay }) else {
            return nil
        }
        
        var weeks = ((lastSatMon - firstMonSun) + 1) / 7
        weeks += firstMonSun > 1 ? 1 : 0
        weeks += lastSatMon < lastDay ? 1 : 0
        
        return [4, 5, 6].contains(weeks) ? weeks : nil
    }

    /// Get the list of dates on the specific Year, Month, Week
    /// Ex) 2019-9-1st week returns [1,2,3,4,5,6,7], 2019-9-5th week returns [29,30]
    static func getDays(year: UInt, month: Month, week: UInt, startsWithMonday: Bool = false) -> [UInt] {
        let targetFirstDayIndex = UInt(startsWithMonday ? 1 : 7) // 1:Sun, 7:Sat
        
        // Dates of the first week
        if week == 1, let firstMonSunday = (1...7).first(where: { weekday(year: year, month: month, day: $0)?.1 == targetFirstDayIndex }) {
            var days: [UInt] = []
            (1...firstMonSunday).forEach { (day) in
                days.append(UInt(day))
            }
            
            if days.count < 7 {
                (0...(7 - days.count - 1)).forEach { (_) in
                    days.insert(0, at: 0)
                }
            }
            
            return days
        } else {
            guard let monsunday = firstMonSunday(year: year, month: month, week: week, startsWithMonday: startsWithMonday) else { return [] }
            var days: [UInt] = [monsunday]
            let lastDay = month.days(year: year)
            var nextDay = monsunday + 1
            while nextDay <= lastDay && days.count < 7 {
                days.append(nextDay)
                nextDay += 1
            }
            
            return days
        }

    }

    /// Gets the date of the Mon/Sun day of the week
    static private func firstMonSunday(year: UInt, month: Month, week: UInt, startsWithMonday: Bool = false) -> UInt? {
        let target = UInt(startsWithMonday ? 2 : 1) // 2:Mon ,1:Sun
        guard let firstTargetDay = (1...7).first(where: { weekday(year: year, month: month, day: $0)?.1 == target }) else {
            return nil
        }
        
        let days = month.days(year: year)
        let intWeek = Int(week)
        
        var targetDays: [UInt] = [UInt(firstTargetDay)]
        var day = UInt(firstTargetDay + 7)
        while day <= days {
            targetDays.append(day)
            day += 7
        }
        
        if firstTargetDay == 1 {
            return (intWeek == 1) ? 1 : targetDays[safe: (intWeek - 1)]
        } else {
            return (intWeek == 1) ? nil : targetDays[safe: (intWeek - 2)]
        }
    }
    
    static func nthWeek(year: UInt, month: Month, week: UInt, startsWithMonday: Bool = false) -> UInt? {
        let target = UInt(startsWithMonday ? 2 : 1) // 2:Mon ,1:Sun
        
        guard week > 1 else { return nil }
        
        // First Mon/Sunday of the year
        guard let firstTargetDayOfTheYear = (1...7).first(where: { weekday(year: year, month: .jan, day: $0)?.1 == target }) else {
            return nil
        }
        guard let firstTargetDayOfTheWeek = firstMonSunday(year: year, month: month, week: week, startsWithMonday: startsWithMonday) else {
            return nil
        }
        
        let yearStartsWithMonOrSun = firstTargetDayOfTheYear == 1
        let nthDayOfTarget = month.nthDayOfTheYear(day: Int(firstTargetDayOfTheWeek), isLeapYear: year.isLeapYear)
        let weeksBeforeTarget = (nthDayOfTarget - firstTargetDayOfTheYear) / 7
        
        return UInt(weeksBeforeTarget + 1 + (yearStartsWithMonOrSun ? 0 : 1))
    }
}

