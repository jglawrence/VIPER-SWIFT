//
//  NSCalendar+CalendarAdditions.swift
//  VIPER-SWIFT
//
//  Created by Conrad Stoll on 6/5/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation

extension NSCalendar {
    class func gregorianCalendar() -> NSCalendar? {
        return NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    }
    
    func dateWithYear(year: Int, month: Int, day: Int) -> NSDate? {
        let components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12

        return dateFromComponents(components)
    }
    
    func dateForTomorrowRelativeToToday(today: NSDate) -> NSDate? {
        let tomorrowComponents = NSDateComponents()
        tomorrowComponents.day = 1

        return dateByAddingComponents(tomorrowComponents, toDate: today, options: [])
    }
    
    func dateForEndOfWeekWithDate(date: NSDate) -> NSDate? {
        let daysRemainingThisWeek = daysRemainingInWeekWithDate(date)
        let remainingDaysComponent = NSDateComponents()
        remainingDaysComponent.day = daysRemainingThisWeek

        return dateByAddingComponents(remainingDaysComponent, toDate: date, options: [])
    }
    
    func dateForBeginningOfDay(date: NSDate) -> NSDate? {
        let newComponent = components([.Year, .Month, .Day], fromDate: date)
        let newDate = dateFromComponents(newComponent)
        return newDate
    }
    
    func dateForEndOfDay(date: NSDate) -> NSDate? {
        guard let toDate = dateForBeginningOfDay(date) else { return nil }

        let components = NSDateComponents()
        components.day = 1
        let nextDay = dateByAddingComponents(components, toDate: toDate, options: [])

        return nextDay
    }
    
    func daysRemainingInWeekWithDate(date: NSDate) -> Int {
        let weekdayComponent = components(.Weekday, fromDate: date)
        let daysRange = rangeOfUnit(.Weekday, inUnit: .WeekOfMonth, forDate: date)
        let daysPerWeek = daysRange.length
        let daysRemaining = daysPerWeek - weekdayComponent.weekday

        return daysRemaining
    }
    
    func dateForEndOfFollowingWeekWithDate(date: NSDate) -> NSDate? {
        guard let endOfWeek = dateForEndOfWeekWithDate(date) else { return nil }
        let nextWeekComponent = NSDateComponents()
        nextWeekComponent.weekOfMonth = 1
        let followingWeekDate = dateByAddingComponents(nextWeekComponent, toDate: endOfWeek, options: [])

        return followingWeekDate
    }
    
    func isDate(date: NSDate, beforeYearMonthDay: NSDate) -> Bool {
        let comparison = compareYearMonthDay(date, toYearMonthDay: beforeYearMonthDay)

        return comparison == .OrderedAscending
    }
    
    func isDate(date: NSDate, equalToYearMonthDay: NSDate) -> Bool {
        let comparison = compareYearMonthDay(date, toYearMonthDay: equalToYearMonthDay)

        return comparison == .OrderedSame
    }
    
    func isDate(date: NSDate, duringSameWeekAsDate: NSDate) -> Bool {
        let dateComponents = components(.WeekOfMonth, fromDate: date)
        let duringSameWeekComponents = components(.WeekOfMonth, fromDate: duringSameWeekAsDate)

        return dateComponents.weekOfMonth == duringSameWeekComponents.weekOfMonth
    }
    
    func isDate(date: NSDate, duringWeekAfterDate: NSDate) -> Bool {
        guard let nextWeek = dateForEndOfFollowingWeekWithDate(duringWeekAfterDate) else { return false }

        let dateComponents = components(.WeekOfMonth, fromDate: date)
        let nextWeekComponents = components(.WeekOfMonth, fromDate: nextWeek)

        return dateComponents.weekOfMonth == nextWeekComponents.weekOfMonth
    }
    
    func compareYearMonthDay(date: NSDate, toYearMonthDay: NSDate) -> NSComparisonResult {
        let dateComponents = yearMonthDayComponentsFromDate(date)
        let yearMonthDayComponents = yearMonthDayComponentsFromDate(toYearMonthDay)
        
        var result = compareInteger(dateComponents.year, right: yearMonthDayComponents.year)
        
        if result == .OrderedSame {
            result = compareInteger(dateComponents.month, right: yearMonthDayComponents.month)
            
            if result == .OrderedSame {
                result = compareInteger(dateComponents.day, right: yearMonthDayComponents.day)
            }
        }
        
        return result
    }
    
    func yearMonthDayComponentsFromDate(date: NSDate) -> NSDateComponents {
        let newComponents = components(([.Year, .Month, .Day]), fromDate: date)

        return newComponents
    }
    
    func compareInteger(left: Int, right: Int) -> NSComparisonResult {
        if left == right {
            return .OrderedSame
        } else if left < right {
            return .OrderedAscending
        } else {
            return .OrderedDescending
        }
    }
    
    func nearTermRelationForDate(date: NSDate, relativeToToday: NSDate) -> NearTermDateRelation {
        var relation: NearTermDateRelation = .OutOfRange
        
        guard let dateForTomorrow = dateForTomorrowRelativeToToday(relativeToToday) else { return relation }
        
        let isDateBeforeYearMonthDay = isDate(date, beforeYearMonthDay: relativeToToday)
        let isDateEqualToYearMonthDay = isDate(date, equalToYearMonthDay: relativeToToday)
        let isDateEqualToYearMonthDayRelativeToTomorrow = isDate(date, equalToYearMonthDay: dateForTomorrow)
        let isDateDuringSameWeekAsDate = isDate(date, duringSameWeekAsDate: relativeToToday)
        let isDateDuringSameWeekAfterDate = isDate(date, duringWeekAfterDate: relativeToToday)
        
        if isDateBeforeYearMonthDay {
            relation = .OutOfRange
        } else if isDateEqualToYearMonthDay {
            relation = .Today
        } else if isDateEqualToYearMonthDayRelativeToTomorrow {
            let isRelativeDateDuringSameWeek = isDate(relativeToToday, duringSameWeekAsDate: date)

            if isRelativeDateDuringSameWeek {
                relation = .Tomorrow
            } else {
                relation = .NextWeek
            }
        } else if isDateDuringSameWeekAsDate {
            relation = .LaterThisWeek
        } else if isDateDuringSameWeekAfterDate {
            relation = .NextWeek
        }
        
        return relation
    }
}