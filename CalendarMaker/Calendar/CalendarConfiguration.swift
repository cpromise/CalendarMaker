//
//  CalendarConfiguration.swift
//  CalendarMaker
//
//  Created by Seonghyun on 2020/04/15.
//  Copyright © 2020 Poodlesoft. All rights reserved.
//

import Foundation
import UIKit

public struct CalendarConfiguration {
    /*
     [S][M][T][W][T][F][S] << dayName
     [ ][ ][ ][1][2][3][4] << dates
     [5][6][7][8][9]......
     */
    
    public var startsWithMonday = false // Week starts on Monday
    public var needsNthWeek = true // Shows week number

    public var colorBackground: UIColor = .white
    public var colorSunday: UIColor = #colorLiteral(red: 0.8, green: 0.09803921569, blue: 0.1176470588, alpha: 1)
    public var colorSaturday: UIColor = #colorLiteral(red: 0.07728873239, green: 0.09803921569, blue: 1, alpha: 1)
    public var colorWeekday: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    public var needsMemo: Bool = true
    public var useSeperator: Bool = true
    
    public var fontBig = UIFont.systemFont(ofSize: 17)
    public var fontSmall = UIFont.systemFont(ofSize: 13)
    public var fontSchedule = UIFont.systemFont(ofSize: 13)
    public var fontWeekNumber = UIFont.systemFont(ofSize: 10)
    
    /**
     Decieds expression of days.
     0: Sun, Mon, Tue...
     1: SUN, MON, TUE...
     2: S, M, T...
     3: 일, 월, 화...
     */
    public var daysNameType: Int = 0
    private var daysNameType1: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    private var daysNameType2: [String] { return daysNameType1.map({ $0.uppercased() }) }
    private var daysNameType3: [String] { return daysNameType2.map({ String($0.prefix(1)) }) }
    private var daysNameType4: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    internal var daysNameList: [String] {
        var defaultDaysList: [String] = {
            switch daysNameType {
            case 0: return daysNameType1
            case 1: return daysNameType2
            case 2: return daysNameType3
            case 3: return daysNameType4
            default: return daysNameType1
            }
        }()
        
        if startsWithMonday {
            defaultDaysList.append(defaultDaysList.remove(at: 0))
        }
        
        return defaultDaysList
    }
    
    public init() { }
}


