//
//  CalendarMaker.swift
//  CalendarMaker
//
//  Created by Seonghyun on 2020/04/15.
//  Copyright © 2020 Poodlesoft. All rights reserved.
//

import UIKit

public typealias Schedule = (name: String, color: UIColor?, backgroundColor: UIColor?)

public class CalendarMaker {
    public var configuration: CalendarConfiguration
    
    private let tagCalendarDayMainLabel_NthWeek = 1910106
    
    public weak var delegate: CalendarMakerDelegate? {
        didSet { updateConfiguration() }
    }
    
    public init(configuration: CalendarConfiguration = CalendarConfiguration()) {
        self.configuration = configuration
    }
    
    /// Created view has constraints of width and height.
    /// You should set constraints of position X and Y
    public func createCalendarView(year: UInt, month: Int) -> UIView? {
        guard let month = Month(rawValue: month) else { return nil }
        
        updateConfiguration()
        
        return createCalendarView(year: year, month: month)
    }
    
    private func updateConfiguration() {
        guard let delegate = delegate else { return }
        configuration.colorSunday = delegate.colorSunday ?? configuration.colorSunday
        configuration.colorSaturday = delegate.colorSaturday ?? configuration.colorSaturday
        configuration.colorWeekday = delegate.colorWeekday ?? configuration.colorWeekday
        
        configuration.fontBig = delegate.fontForDate(dateSizeIsBig: true)
        configuration.fontSmall = delegate.fontForDate(dateSizeIsBig: false)
        configuration.fontSchedule = delegate.fontForSchedule() ?? configuration.fontSmall
        configuration.fontWeekNumber = delegate.fontForWeekNumber() ?? configuration.fontWeekNumber
    }
    
    private func createCalendarView(year: UInt, month: Month) -> UIView {
        let container = UIStackView()
        container.distribution = .fillProportionally
        container.axis = .vertical
                
        guard let weeks = CalendarUtil.numberOfWeeks(year: year, month: month, startsWithMonday: configuration.startsWithMonday) else { return container }
        
        let width = delegate?.widthForCalendar() ?? (UIScreen.main.bounds.size.width - 40)
        let topLineHeight: CGFloat = delegate?.heightForEachWeek() ?? (width / 7)
        container.widthAnchor.constraint(equalToConstant: width).isActive = true
        container.heightAnchor.constraint(equalToConstant: (topLineHeight) * CGFloat(weeks) + topLineHeight).isActive = true
        
        let topLine = createHorizontalStackView(isTopLine: true)
        topLine.heightAnchor.constraint(equalToConstant: topLineHeight).isActive = true
        container.addArrangedSubview(topLine)
        
        (1...weeks).forEach { (week) in
            let days = CalendarUtil.getDays(year: year,
                                                   month: month,
                                                   week: UInt(week),
                                                   startsWithMonday: configuration.startsWithMonday)
            let weekView = createHorizontalStackView(days: days, yearAndMonth: YearAndMonth(year: year, month: month), week: week)
            weekView.heightAnchor.constraint(equalToConstant: topLineHeight).isActive = true
            
            container.addArrangedSubview(weekView)
        }
        
        return container
    }
    
    private func createHorizontalStackView(days: [UInt]? = nil, schedules: [Int: Schedule]? = nil, isTopLine: Bool = false, yearAndMonth: YearAndMonth? = nil, week: Int? = nil) -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 0
        
        (1...7).forEach { (index) in
            let view = UIView()
            view.backgroundColor = configuration.colorBackground
            
            let label: UILabel = {
                switch (index, configuration.startsWithMonday) {
                case (1, false), (7, true): return UILabel.Sunday(fontColor: configuration.colorSunday)
                case (7, false), (6, true): return UILabel.Saturday(fontColor: configuration.colorSaturday)
                default: return UILabel.Weekday(fontColor: configuration.colorWeekday, day: index)
                }
            }()
            
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            stackView.addArrangedSubview(view)
            
            let willAddNthWeek = index == 1 && configuration.needsNthWeek && ((days?.last ?? 0) > 7)
            
            if isTopLine {
                label.text = configuration.daysNameList[index - 1]
                label.fillToSuperview()
                label.font = configuration.fontBig
            } else if let days = days, let yearAndMonth = yearAndMonth {
                let day = days[safe: (index - 1)] ?? 0
                label.text = (day > 0) ? "\(day)" : ""
                label.adjustConfiguration(config: configuration, willAddNthWeek: willAddNthWeek)
                
                if delegate?.isHoliday(year: yearAndMonth.year, month: yearAndMonth.month, date: day) ?? false {
                    label.textColor = configuration.colorSunday
                }
                
                if configuration.needsMemo, let schedule = delegate?.schedule(year: yearAndMonth.year, month: yearAndMonth.month, date: day) ?? schedules?[Int(day)] {
                    addSchedule(schedule: schedule, on: view, font: delegate?.fontForSchedule())
                }
                
                if let week = week, willAddNthWeek,
                    let nthWeek = CalendarUtil.nthWeek(year: yearAndMonth.year, month: yearAndMonth.month, week: UInt(week), startsWithMonday: configuration.startsWithMonday) {
                    addNthWeekView(on: view, nthWeek: nthWeek, configuration: configuration)
                }

                if !isTopLine && configuration.useSeperator {
                    if willAddNthWeek, let nthLabel = view.viewWithTag(tagCalendarDayMainLabel_NthWeek) {
                        view.addTopBorderNext(to: nthLabel, color: label.textColor, paddingHorizontal: 2)
                    } else {
                        view.addTopBorder(color: label.textColor, paddingHorizontal: 2)
                    }
                }
            } else {
                
            }
        }
        
        return stackView
    }
    
    private func addNthWeekView(on view: UIView, nthWeek: UInt, configuration: CalendarConfiguration) {
        let label = configuration.startsWithMonday ?
            UILabel.Weekday(fontColor: configuration.colorWeekday.withAlphaComponent(0.8), day: 0) :
            UILabel.Sunday(fontColor: configuration.colorSunday.withAlphaComponent(0.8))
        label.text = "\(nthWeek)"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = configuration.fontWeekNumber
        label.tag = tagCalendarDayMainLabel_NthWeek
        view.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        label.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
    }
    
    /// Example of how to add text on the calendar
    private func addSchedule(schedule: Schedule, on view: UIView, font: UIFont? = nil) {
        let labelSchedule = UILabel()
        view.addSubview(labelSchedule)
        
        labelSchedule.translatesAutoresizingMaskIntoConstraints = false
        labelSchedule.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelSchedule.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -4).isActive = true
        labelSchedule.font = font ?? UIFont.systemFont(ofSize: 7)
        labelSchedule.backgroundColor = schedule.backgroundColor ?? .clear
        labelSchedule.textColor = schedule.color
        labelSchedule.text = schedule.name
        
        
        if let upperLabel = view.subviews.first(where: { $0 is UILabel }) {
            labelSchedule.topAnchor.constraint(equalTo: upperLabel.bottomAnchor, constant: 2).isActive = true
        } else {
            labelSchedule.topAnchor.constraint(equalTo: view.topAnchor, constant: 14).isActive = true
        }
    }
}

extension UILabel {
    fileprivate func adjustConfiguration(config: CalendarConfiguration, willAddNthWeek: Bool) {
        font = config.needsMemo ? config.fontSmall : config.fontBig
        if config.needsMemo {
            positionTopLeft(leftConstant: willAddNthWeek ? 14: 5)
            font = config.fontSmall
        } else {
            fillToSuperview()
            font = config.fontBig
        }
    }
}

public protocol CalendarMakerDelegate: NSObjectProtocol {
    var colorSunday: UIColor? { get }
    var colorSaturday: UIColor? { get }
    var colorWeekday: UIColor? { get }

    func widthForCalendar() -> CGFloat
    func heightForEachWeek() -> CGFloat
    
    func fontForDate(dateSizeIsBig: Bool) -> UIFont
    func fontForSchedule() -> UIFont?
    func fontForWeekNumber() -> UIFont?
        
    func schedule(year: UInt, month: Month, date: UInt) -> Schedule?
    
    func isHoliday(year: UInt, month: Month, date: UInt) -> Bool
}

extension CalendarMakerDelegate {
    var colorSunday: UIColor? { nil }
    var colorSaturday: UIColor? { nil }
    var colorWeekday: UIColor? { nil }
    
    func fontForDate(dateSizeIsBig: Bool) -> UIFont {
        UIFont.systemFont(ofSize: dateSizeIsBig ? 17 : 13)
    }
    
    func fontForSchedule() -> UIFont? { nil }
    
    func fontForWeekNumber() -> UIFont? { nil }
    
    func schedule(year: UInt, month: Month, date: UInt) -> Schedule? { nil }

    func isHoliday(year: UInt, month: Month, date: UInt) -> Bool { false }
}

