//
//  Item+ex.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import Foundation
import CoreData
import SwiftUI

extension Item {
    var needSetNewStatus: Bool {
        needMoveToThisWeek || needMoveToThisMonth || needMoveToArchive
    }
    
    var getNewStatus: Status {
        if needMoveToThisWeek {
            return .thisWeek
        } else if needMoveToThisMonth {
            return .thisMonth
        } else if needMoveToArchive {
            return .archive
        }
        
        return status
    }
    
    func updateStatusIfNeeded() {
        if let date = lastTimeStatusChanged, date.isDateToday() || isArchived { return }
        
        if let date = Date().lastSundayOfMonth(for: additionTime), date <= Date() {
            needMoveToArchive = true
        } else {
            switch status.id {
                case 0:
                    if let date = Date().firstSunday(after: additionTime), date <= Date() {
                        needMoveToThisMonth = true
                    } else if Date().isNextDay(from: additionTime) {
                        needMoveToThisWeek = true
                    }
                case 1:
                    if let date = Date().firstSunday(after: additionTime), date <= Date() {
                        needMoveToThisMonth = true
                    }
                default:
                    break
            }
        }
    }
    
    /// - Throughout the day (several times as new phrases are added) →  inbox  + Source tag   +
    /// - In the morning (after one full night's sleep) →  this week
    /// - After a week →  this month
    /// - One month later →   archive   + #2024-2(Archive tag)
    /// - After three months
    /// - Six months later
    /// - One year later
    func setReadyToRepeat() {
        // phrase should be repeated throughout the day several times
        guard let lastRepetitionDate = lastRepetition else { isReadyToRepeat = true; return }
        
        let firstSunday = Date().firstSunday(after: lastRepetitionDate)
        let isLastRepetitionDateToday = lastRepetitionDate.isDateToday()
        
        switch status.id {
                // input, should be repeatet throughout the day
            case 0:
                isReadyToRepeat = true
                // this week, should be repeatet once a day
            case 1:
                isReadyToRepeat = !isLastRepetitionDateToday
                // this month, should be repeated every sunday throughout the month
            case 2:
                if let firstSundayAfterLastRepetition = firstSunday, Date() >= firstSundayAfterLastRepetition {
                    isReadyToRepeat = true
                } else {
                    isReadyToRepeat = false
                }
                // archive, should be repeated one month later, three months later, Six months later, one year later
            case 3:
                if let lastTimeStatusChanged = lastTimeStatusChanged {
                    if Date().daysAgo(from: lastTimeStatusChanged) >= 30,
                       Date().daysAgo(from: lastRepetitionDate) >= 30 {
                        isReadyToRepeat = true
                    } else if Date().daysAgo(from: lastTimeStatusChanged) >= 90,
                              Date().daysAgo(from: lastRepetitionDate) >= 60 {
                        isReadyToRepeat = true
                    } else if Date().daysAgo(from: lastTimeStatusChanged) >= 180,
                              Date().daysAgo(from: lastRepetitionDate) >= 90 {
                        isReadyToRepeat = true
                    } else if Date().daysAgo(from: lastTimeStatusChanged) >= 360,
                              Date().daysAgo(from: lastRepetitionDate) >= 180 {
                        isReadyToRepeat = true
                    }
                } else {
                    isReadyToRepeat = false
                }
            default:
                break
        }
    }
    
    func setNewStatus() {
        if needMoveToThisWeek {
            status = .thisWeek
            needMoveToThisWeek = false
        } else if needMoveToThisMonth {
            status = .thisMonth
            needMoveToThisMonth = false
        } else if needMoveToArchive {
            status = .archive
            isArchived = true
            needMoveToArchive = false
        }
        
        lastTimeStatusChanged = Date()
    }
    
    func incrementCounter() {
        repetitionCounter += 1
        lastRepetition = Date()
    }
}
