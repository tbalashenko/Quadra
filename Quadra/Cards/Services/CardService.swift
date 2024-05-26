//
//  CardService.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/05/2024.
//

import Foundation
import CoreData

class CardService: ObservableObject {
    @Published var cards = [Card]()
    static let shared = CardService()
    
    let dataController = DataController.shared
    
    private init() {
        updateCards()
    }
    
    func updateCards() {
        do {
            cards = try fetchCards()
        } catch {
            print("Error fetching cards \(error.localizedDescription)")
        }
    }
    
    private func fetchCards() throws -> [Card] {
        let fetchRequest: NSFetchRequest<Card> = Card.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "additionTime", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let cards = try dataController.container.viewContext.fetch(fetchRequest)
            cards.forEach { card in
                cheekIfStatusNeedUpdate(card: card)
                setReadyToRepeat(card: card)
            }
            return cards
        } catch {
            throw DataServiceError.fetchFailed(description: "Failed to fetch cards: \(error.localizedDescription)")
        }
    }
    
    func saveEmptyCard(
        phraseToRemember: NSAttributedString = NSAttributedString(string: ""),
        additionDate: Date = Date()
    ) throws -> Card {
        let context = dataController.container.viewContext
        let card = Card(context: context)
        
        card.phraseToRemember = phraseToRemember
        card.status = .input
        card.id = UUID()
        card.additionTime = additionDate

        var tag: CardArchiveTag? = nil
        
        do {
            if let archiveTag = try ArchiveTagService.shared.getArchiveTag(date: additionDate) {
                tag = archiveTag
            }
        } catch {
            throw DataServiceError.saveFailed(description: "Failed to save tag: \(error.localizedDescription)")
        }
        
        do {
            try dataController.container.viewContext.save()
            if let tag = tag {
                tag.addToCards(card)
            }
            
            do {
                cards = try fetchCards()
            } catch {
                print("Error fetching cards \(error.localizedDescription)")
            }
            
            return card
        } catch {
            throw DataServiceError.saveFailed(description: "Failed to save card: \(error.localizedDescription)")
        }
    }

    
    func editCard(
        card: Card,
        phraseToRemember: NSAttributedString,
        translation: NSAttributedString? = nil,
        transcription: String? = nil,
        imageData: Data? = nil,
        sources: [CardSource]
    ) throws -> Card {
        card.phraseToRemember = phraseToRemember
        card.translation = translation
        card.transcription = transcription
        card.image = imageData
        sources.forEach {
            card.addToSources($0)
            $0.addToCards(card)
        }
        
        do {
            try dataController.container.viewContext.save()
            
            do {
                cards = try fetchCards()
            } catch {
                print("Error fetching cards \(error.localizedDescription)")
            }
            
            return card
        } catch {
            throw DataServiceError.saveFailed(description: "Failed to save card: \(error.localizedDescription)")
        }
    }
    
    func incrementCounter(card: Card) throws {
        card.repetitionCounter += 1
        card.lastRepetition = Date()
        
        do {
            try dataController.container.viewContext.save()
        } catch {
            throw DataServiceError.saveFailed(description: "Failed to save card: \(error.localizedDescription)")
        }
    }
    
    /// - Throughout the day (several times as new phrases are added) →  inbox  + Source tag   +
    /// - In the morning (after one full night's sleep) →  this week
    /// - After a week →  this month
    /// - One month later →  archive   + #2024-2(Archive tag)
    /// - After three months
    /// - Six months later
    /// - One year later
    func setReadyToRepeat(card: Card) {
        // phrase should be repeated throughout the day several times
        guard let lastRepetitionDate = card.lastRepetition else {
            card.isReadyToRepeat = true
            
            try? dataController.container.viewContext.save()
            
            return
        }
        
        let firstSunday = Date().firstSunday(after: lastRepetitionDate)
        let isLastRepetitionDateToday = lastRepetitionDate.isDateToday()
        
        switch card.status.id {
                // input, should be repeatet throughout the day
            case 0:
                card.isReadyToRepeat = true
                // this week, should be repeatet once a day
            case 1:
                card.isReadyToRepeat = !isLastRepetitionDateToday
                // this month, should be repeated every sunday throughout the month
            case 2:
                if let firstSundayAfterLastRepetition = firstSunday, Date() >= firstSundayAfterLastRepetition {
                    card.isReadyToRepeat = true
                } else {
                    card.isReadyToRepeat = false
                }
                // archive, should be repeated one month later, three months later, Six months later, one year later
            case 3:
                if let lastTimeStatusChanged = card.lastTimeStatusChanged {
                    if Date().daysAgo(from: lastTimeStatusChanged) >= 30,
                       Date().daysAgo(from: lastRepetitionDate) >= 30 {
                        card.isReadyToRepeat = true
                    } else if Date().daysAgo(from: lastTimeStatusChanged) >= 90,
                              Date().daysAgo(from: lastRepetitionDate) >= 60 {
                        card.isReadyToRepeat = true
                    } else if Date().daysAgo(from: lastTimeStatusChanged) >= 180,
                              Date().daysAgo(from: lastRepetitionDate) >= 90 {
                        card.isReadyToRepeat = true
                    } else if Date().daysAgo(from: lastTimeStatusChanged) >= 360,
                              Date().daysAgo(from: lastRepetitionDate) >= 180 {
                        card.isReadyToRepeat = true
                    }
                } else {
                    card.isReadyToRepeat = false
                }
            default:
                break
        }
        
        do {
            try dataController.container.viewContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func setNewStatus(card: Card) {
        if card.needMoveToThisWeek {
            card.status = .thisWeek
            card.needMoveToThisWeek = false
        } else if card.needMoveToThisMonth {
            card.status = .thisMonth
            card.needMoveToThisMonth = false
        } else if card.needMoveToArchive {
            card.status = .archive
            card.isArchived = true
            card.needMoveToArchive = false
        }
        
        card.lastTimeStatusChanged = Date()
        
        do {
            try dataController.container.viewContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func cheekIfStatusNeedUpdate(card: Card) {
        if let date = card.lastTimeStatusChanged, date.isDateToday() || card.isArchived { return }
        
        if let date = Date().lastSundayOfMonth(for: card.additionTime), date <= Date() {
            card.needMoveToArchive = true
        } else {
            switch card.status.id {
                case 0:
                    if let date = Date().firstSunday(after: card.additionTime), date <= Date() {
                        card.needMoveToThisMonth = true
                    } else if Date().isNextDay(from: card.additionTime) {
                        card.needMoveToThisWeek = true
                    }
                case 1:
                    if let date = Date().firstSunday(after: card.additionTime), date <= Date() {
                        card.needMoveToThisMonth = true
                    }
                default:
                    break
            }
        }
        
        do {
            try dataController.container.viewContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func delete(card: Card) throws {
        dataController.container.viewContext.delete(card)
        
        do {
            try dataController.container.viewContext.save()
        } catch {
            throw DataServiceError.saveFailed(description: "Failed to delete card: \(error.localizedDescription)")
        }
    }
}
