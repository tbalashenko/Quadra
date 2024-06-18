//
//  Card+ex.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI

extension Card {
    var stringPhraseToRemember: String {
        String(convertedPhraseToRemember.characters)
    }
    
    var convertedPhraseToRemember: AttributedString {
        AttributedString(phraseToRemember)
    }
    
    var stringTranslation: String? {
        guard let translation = translation else { return nil }
        
        let atrStr = AttributedString(translation)
        
        return String(atrStr.characters)
    }
    
    var convertedTranslation: AttributedString? {
        guard let translation = translation, !translation.string.isEmpty else { return nil }
        
        return AttributedString(translation)
    }
    
    var formattedTranscription: String? {
        guard let transcription = transcription, !transcription.isEmpty else { return nil }
        
        return "[" + transcription + "]"
    }
    
    var convertedImage: Image? {
        guard
            let imageData = image,
            let uiImage = UIImage(data: imageData)
        else { return nil }
        
        return Image(uiImage: uiImage)
    }
    
    var convertedCroppedImage: Image? {
        guard
            let imageData = croppedImage,
            let uiImage = UIImage(data: imageData)
        else { return nil }
        
        return Image(uiImage: uiImage)
    }
    
    var needSetNewStatus: Bool {
        needMoveToThisWeek || needMoveToThisMonth || needMoveToArchive
    }
    
    var getNewStatus: CardStatus {
        if needMoveToThisWeek {
            return .thisWeek
        } else if needMoveToThisMonth {
            return .thisMonth
        } else if needMoveToArchive {
            return .archive
        }
        
        return cardStatus
    }
    
    /// - Throughout the day (several times as new phrases are added) →  inbox  + Source tag   +
    /// - In the morning (after one full night's sleep) →  this week
    /// - After a week →  this month
    /// - One month later →  archive   + #2024-2(Archive tag)
    /// - After three months
    /// - Six months later
    /// - One year later
    var isReadyToRepeat: Bool {
        // phrase should be repeated throughout the day several times
        guard let lastRepetitionDate = lastRepetition else { return true }
        
        let firstSunday = Date().firstSunday(after: lastRepetitionDate)
        let isLastRepetitionDateToday = lastRepetitionDate.isDateToday()
        
        switch cardStatus.id {
                // input, should be repeatet throughout the day
            case 0:
                return true
                // this week, should be repeatet once a day
            case 1:
                return !isLastRepetitionDateToday
                // this month, should be repeated every sunday throughout the month
            case 2:
                if let firstSundayAfterLastRepetition = firstSunday, Date() >= firstSundayAfterLastRepetition {
                    return true
                } else {
                    return false
                }
                // archive, should be repeated one month later, three months later, Six months later, one year later
            case 3:
                if let lastTimeStatusChanged {
                    if Date().daysAgo(from: lastTimeStatusChanged) >= 30,
                       Date().daysAgo(from: lastRepetitionDate) >= 30 {
                        return true
                    } else if Date().daysAgo(from: lastTimeStatusChanged) >= 90,
                              Date().daysAgo(from: lastRepetitionDate) >= 60 {
                        return true
                    } else if Date().daysAgo(from: lastTimeStatusChanged) >= 180,
                              Date().daysAgo(from: lastRepetitionDate) >= 90 {
                        return true
                    } else if Date().daysAgo(from: lastTimeStatusChanged) >= 360,
                              Date().daysAgo(from: lastRepetitionDate) >= 180 {
                        return true
                    }
                } else {
                    return false
                }
            default:
                break
        }
        
        return false
    }
    
    var needMoveToArchive: Bool {
        if let date = lastTimeStatusChanged, date.isDateToday() || isArchived { return false }
        
        if let date = Date().lastSundayOfMonth(for: additionTime), date <= Date() {
            return true
        }
        
        return false
    }
    
    var needMoveToThisMonth: Bool {
        if let date = lastTimeStatusChanged, date.isDateToday() || isArchived { return false }
        
        if (cardStatus.id == 0 || cardStatus.id == 1) , let date = Date().firstSunday(after: additionTime), date <= Date() {
            return true
        }
        
        return false
    }
    
    var needMoveToThisWeek: Bool {
        if let date = lastTimeStatusChanged, date.isDateToday() || isArchived { return false }
        
        if cardStatus.id == 0, Date().isNextDay(from: additionTime) {
            return true
        }
        
        return false
    }
}

