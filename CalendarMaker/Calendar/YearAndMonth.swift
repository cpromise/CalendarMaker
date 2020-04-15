//
//  YearAndMonth.swift
//  CalendarMaker
//
//  Created by Seonghyun on 2020/04/15.
//  Copyright © 2020 Poodlesoft. All rights reserved.
//

import Foundation

internal struct YearAndMonth {
    let year: UInt
    let month: Month
    
    static var thisMonth: YearAndMonth {
        let date = Date()
        return YearAndMonth(year: UInt(date.year), month: Month(rawValue: date.month) ?? .jan)
    }
    
    static var nextMonth: YearAndMonth {
        let date = Date()
        let month = date.month == 12 ? 1 : (date.month + 1)
        return YearAndMonth(year: UInt(date.month == 12 ? (date.year + 1) : date.year), month: Month(rawValue: month) ?? .jan)
    }
}
