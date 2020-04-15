//
//  Extensions.swift
//  CalendarMaker
//
//  Created by Seonghyun on 2020/04/15.
//  Copyright © 2020 Poodlesoft. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    /// SwifterSwift: User’s current calendar.
    var calendar: Calendar {
        return Calendar(identifier: Calendar.current.identifier) // Workaround to segfault on corelibs foundation https://bugs.swift.org/browse/SR-10147
    }

    /// SwifterSwift: Year.
    ///
    ///        Date().year -> 2017
    ///
    ///        var someDate = Date()
    ///        someDate.year = 2000 // sets someDate's year to 2000
    ///
    var year: Int {
        get {
            return calendar.component(.year, from: self)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = calendar.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            if let date = calendar.date(byAdding: .year, value: yearsToAdd, to: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Month.
    ///
    ///     Date().month -> 1
    ///
    ///     var someDate = Date()
    ///     someDate.month = 10 // sets someDate's month to 10.
    ///
    var month: Int {
        get {
            return calendar.component(.month, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentMonth = calendar.component(.month, from: self)
            let monthsToAdd = newValue - currentMonth
            if let date = calendar.date(byAdding: .month, value: monthsToAdd, to: self) {
                self = date
            }
        }
    }

    /// SwifterSwift: Day.
    ///
    ///     Date().day -> 12
    ///
    ///     var someDate = Date()
    ///     someDate.day = 1 // sets someDate's day of month to 1.
    ///
    var day: Int {
        get {
            return calendar.component(.day, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }

            let currentDay = calendar.component(.day, from: self)
            let daysToAdd = newValue - currentDay
            if let date = calendar.date(byAdding: .day, value: daysToAdd, to: self) {
                self = date
            }
        }
    }
}

extension UInt {
    var isLeapYear: Bool {
        return ((self % 4 == 0) && (self % 100 != 0) || (self % 400 == 0))
    }
}

extension UILabel {
    @discardableResult
    func positionTopLeft(leftConstant: CGFloat = 5) -> Bool {
        guard let view = superview else { return false }
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: leftConstant).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: 2).isActive = true
        
        return true
    }
    
    static func defaultSize() -> CGFloat {
        return UIScreen.main.bounds.width > 320 ? 17 : 15
    }
    
    static func Sunday(fontSize: CGFloat = defaultSize(), fontColor: UIColor = .red, backgroundColor: UIColor = .clear) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        label.textColor = fontColor
        label.backgroundColor = backgroundColor
        label.textAlignment = .center
        label.text = "Sun"
        return label
    }
    
    static func Saturday(fontSize: CGFloat = defaultSize(), fontColor: UIColor = .blue, backgroundColor: UIColor = .clear) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        label.textColor = fontColor
        label.backgroundColor = backgroundColor
        label.textAlignment = .center
        label.text = "Sat"
        return label
    }
    
    static func Weekday(fontSize: CGFloat = defaultSize(), fontColor: UIColor = .black, backgroundColor: UIColor = .clear, day: Int) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        label.textColor = fontColor
        label.backgroundColor = backgroundColor
        label.textAlignment = .center
        
        switch day {
        case 2: label.text = "Mon"
        case 3: label.text = "Tue"
        case 4: label.text = "Wed"
        case 5: label.text = "Thu"
        case 6: label.text = "Fri"
        default: break
        }
        return label
    }
}

extension UIView {
    /// SwifterSwift: Anchor all sides of the view into it's superview.
    @available(iOS 9, *)
    func fillToSuperview() {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            let left = leftAnchor.constraint(equalTo: superview.leftAnchor)
            let right = rightAnchor.constraint(equalTo: superview.rightAnchor)
            let top = topAnchor.constraint(equalTo: superview.topAnchor)
            let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            NSLayoutConstraint.activate([left, right, top, bottom])
        }
    }
    
    func addTopBorder(color: UIColor, paddingHorizontal: CGFloat = 0, width: CGFloat = 1) {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        addSubview(border)
        
        border.topAnchor.constraint(equalTo: topAnchor).isActive = true
        border.leftAnchor.constraint(equalTo: leftAnchor, constant: paddingHorizontal).isActive = true
        border.rightAnchor.constraint(equalTo: rightAnchor, constant: -paddingHorizontal).isActive = true
        border.heightAnchor.constraint(equalToConstant: width).isActive = true
        
        border.backgroundColor = color
    }

    func addTopBorderNext(to leftView: UIView, color: UIColor, paddingHorizontal: CGFloat = 0, width: CGFloat = 1) {
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        addSubview(border)
        
        border.topAnchor.constraint(equalTo: topAnchor).isActive = true
        border.leftAnchor.constraint(equalTo: leftView.rightAnchor, constant: paddingHorizontal).isActive = true
        border.rightAnchor.constraint(equalTo: rightAnchor, constant: -paddingHorizontal).isActive = true
        border.heightAnchor.constraint(equalToConstant: width).isActive = true
        
        border.backgroundColor = color
    }
}

// MARK: - Methods
public extension Collection {

    #if canImport(Dispatch)
    /// SwifterSwift: Performs `each` closure for each element of collection in parallel.
    ///
    ///        array.forEachInParallel { item in
    ///            print(item)
    ///        }
    ///
    /// - Parameter each: closure to run for each element.
    func forEachInParallel(_ each: (Self.Element) -> Void) {
        let indicesArray = Array(indices)
        DispatchQueue.concurrentPerform(iterations: indicesArray.count) { (index) in
            let elementIndex = indicesArray[index]
            each(self[elementIndex])
        }
    }
    #endif

    /// SwifterSwift: Safe protects the array from out of bounds by use of optional.
    ///
    ///        let arr = [1, 2, 3, 4, 5]
    ///        arr[safe: 1] -> 2
    ///        arr[safe: 10] -> nil
    ///
    /// - Parameter index: index of element to access element.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    /// SwifterSwift: Returns an array of slices of length "size" from the array. If array can't be split evenly, the final slice will be the remaining elements.
    ///
    ///     [0, 2, 4, 7].group(by: 2) -> [[0, 2], [4, 7]]
    ///     [0, 2, 4, 7, 6].group(by: 2) -> [[0, 2], [4, 7], [6]]
    ///
    /// - Parameter size: The size of the slices to be returned.
    /// - Returns: grouped self.
    func group(by size: Int) -> [[Element]]? {
        // Inspired by: https://lodash.com/docs/4.17.4#chunk
        guard size > 0, !isEmpty else { return nil }
        var start = startIndex
        var slices = [[Element]]()
        while start != endIndex {
            let end = index(start, offsetBy: size, limitedBy: endIndex) ?? endIndex
            slices.append(Array(self[start..<end]))
            start = end
        }
        return slices
    }

}

