//
//  Month.swift
//  CalendarMaker
//
//  Created by Seonghyun on 2020/04/15.
//  Copyright © 2020 Poodlesoft. All rights reserved.
//

import Foundation

public enum Month: Int {
    case jan = 1, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
    
    func days(year: UInt) -> Int {
        switch self {
        case .jan, .mar, .may, .jul, .aug, .oct, .dec: return 31
        case .apr, .jun, .sep, .nov: return 30
        case .feb: return year.isLeapYear ? 29 : 28
        }
    }
    
    func nthDayOfTheYear(day: Int, isLeapYear: Bool = false) -> Int {
        let previousDays: Int = {
            var previous = 0
            switch self {
            case .jan: previous += 0
            case .feb: previous += 31
            case .mar: previous += 31 + (isLeapYear ? 29 : 28)
            case .apr: previous += 31 + (isLeapYear ? 29 : 28) + 31
            case .may: previous += 31 + (isLeapYear ? 29 : 28) + 31 + 30
            case .jun: previous += 31 + (isLeapYear ? 29 : 28) + 31 + 30 + 31
            case .jul: previous += 31 + (isLeapYear ? 29 : 28) + 31 + 30 + 31 + 30
            case .aug: previous += 31 + (isLeapYear ? 29 : 28) + 31 + 30 + 31 + 30 + 31
            case .sep: previous += 31 + (isLeapYear ? 29 : 28) + 31 + 30 + 31 + 30 + 31 + 31
            case .oct: previous += 31 + (isLeapYear ? 29 : 28) + 31 + 30 + 31 + 30 + 31 + 31 + 30
            case .nov: previous += 31 + (isLeapYear ? 29 : 28) + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31
            case .dec: previous += 31 + (isLeapYear ? 29 : 28) + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31 + 30
            }
            return previous
        }()
        
        return previousDays + day
    }
}
