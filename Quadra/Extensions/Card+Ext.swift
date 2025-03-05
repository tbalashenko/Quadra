//
//  Card+ex.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI
import CoreData

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
    
    var isImageDark: Bool? {
        guard
            let imageData = croppedImage,
            let uiImage = UIImage(data: imageData),
            let uiColor = uiImage.averageColor
        else { return nil }
        
        return Color(uiColor).isDark
    }
    
    var currentStatus: CardStatus? {
        return CardStatus(rawValue: cardStatus)
    }
    
    var getNewStatus: CardStatus {
        if currentStatus == .input, Date().daysAgo(from: additionTime) < 1 {
            return .input
        } else {
            return currentStatus?.next() ?? .input
        }
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
        
        switch cardStatus {
                // input, should be repeatet throughout the day
            case 0:
                return true
                // nextDay, should be repeatet the next day since addition
            case 1:
                if Date().daysAgo(from: additionTime) >= 1,  Date().daysAgo(from: lastRepetitionDate) >= 1 {
                    return true
                }
                // day7, should be repeated 7 days since addition
            case 7:
                if Date().daysAgo(from: additionTime) >= 7,  Date().daysAgo(from: lastRepetitionDate) >= 7 {
                    return true
                }
                // day30, should be repeated 30 days since addition
            case 30:
                if Date().daysAgo(from: additionTime) >= 30,  Date().daysAgo(from: lastRepetitionDate) >= 30 {
                    return true
                }
                // day60, should be repeated 60 days since addition
            case 60:
                if Date().daysAgo(from: additionTime) >= 60,  Date().daysAgo(from: lastRepetitionDate) >= 60 {
                    return true
                }
                // day90, should be repeated 30 days since addition
            case 90:
                if Date().daysAgo(from: additionTime) >= 90,  Date().daysAgo(from: lastRepetitionDate) >= 90 {
                    return true
                }
            default:
                break
        }
        
        return false
    }
    
    convenience init(
        context: NSManagedObjectContext,
        additionTime: Date,
        cardStatus: Int,
        croppedImage: Data? = nil,
        id: UUID? = UUID(),
        image: Data? = nil,
        isArchived: Bool = false,
        lastRepetition: Date? = nil,
        lastTimeStatusChanged: Date? = nil,
        phraseToRemember: NSAttributedString,
        repetitionCounter: Int64 = 0,
        transcription: String? = nil,
        translation: NSAttributedString? = nil,
        archiveTag: CardArchiveTag? = nil,
        sources: NSSet? = nil
    ) {
        let entity = NSEntityDescription.entity(forEntityName: "Card", in: context)!
        self.init(entity: entity, insertInto: context)
        
        self.additionTime = additionTime
        self.cardStatus = cardStatus
        self.croppedImage = croppedImage
        self.id = id
        self.image = image
        self.isArchived = isArchived
        self.lastRepetition = lastRepetition
        self.lastTimeStatusChanged = lastTimeStatusChanged
        self.phraseToRemember = phraseToRemember
        self.repetitionCounter = repetitionCounter
        self.transcription = transcription
        self.translation = translation
        self.archiveTag = archiveTag
        self.sources = sources
    }
    
    // MARK: - Equatable
    public static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id &&
        lhs.phraseToRemember == rhs.phraseToRemember &&
        lhs.translation == rhs.translation &&
        lhs.transcription == rhs.transcription &&
        lhs.sources == rhs.sources &&
        lhs.cardStatus == rhs.cardStatus &&
        lhs.additionTime == rhs.additionTime
    }
}

extension CaseIterable where Self: Equatable {
    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.endIndex : next]
    }
}
