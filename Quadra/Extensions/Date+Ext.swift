//
//  Date+Ext.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 22/03/2024.
//

import Foundation

extension Date {
    func prepareTag() -> String {
        let calendar = Calendar.current

        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let formattedMonth = String(format: "%02d", month)
        
        return "#\(year)-\(formattedMonth)"
    }
    
    func isNextDay(from date: Date) -> Bool {
        let currentDate = Date()
        
        guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date) else {
            return false
        }
        
        if Calendar.current.isDate(nextDay, inSameDayAs: currentDate) { return true }
        
        return currentDate >= nextDay
    }
    
    func firstSunday(after date: Date) -> Date? {
        let calendar = Calendar.current
        
        if let nextSunday = calendar.date(bySetting: .weekday, value: 1, of: date) {
            if calendar.isDate(nextSunday, equalTo: date, toGranularity: .day) {
                return nextSunday
            } else {
                return calendar.nextDate(after: date, matching: DateComponents(weekday: 1), matchingPolicy: .nextTime)
            }
        }
        
        return nil
    }
    
    func lastSundayOfMonth(for date: Date) -> Date? {
        let calendar = Calendar.current

        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        guard let monthRange = calendar.range(of: .day, in: .month, for: date) else {
            return nil
        }
        
        let lastDayOfMonth = monthRange.upperBound - 1
        
        // Iterate backward from the last day of the month until find a Sunday
        for day in (0...6).reversed() {
            let currentDate = calendar.date(from: DateComponents(year: year, month: month, day: lastDayOfMonth - day))
            if let currentDate = currentDate, calendar.component(.weekday, from: currentDate) == 1 {
                return currentDate
            }
        }
        
        return nil
    }
    
    func daysAgo(from date: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: date, to: now)
        return components.day ?? 0
    }
    
    
    func isDateToday() -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let otherDate = calendar.startOfDay(for: self)
        return today == otherDate
    }
    
    func subtractingDays(_ days: Int) -> Date? {
        Calendar.current.date(byAdding: .day, value: -days, to: self)
    }
}
