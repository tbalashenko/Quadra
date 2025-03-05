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
            return cards
        } catch {
            throw DataServiceError.fetchFailed(description: "Failed to fetch cards: \(error.localizedDescription)")
        }
    }

    func saveCard(
        phraseToRemember: AttributedString,
        additionDate: Date = Date(),
        translation: AttributedString? = nil,
        transcription: String? = nil,
        croppedImageData: Data? = nil,
        imageData: Data? = nil,
        sources: [CardSource] = [],
        incrementAddedItemsCounter: Bool = true
    ) throws {
        let context = dataController.container.viewContext
        
        let card = Card(context: context)
        
        card.phraseToRemember = NSAttributedString(phraseToRemember)
        if let translation {
            card.translation =  NSAttributedString(translation)
        }
        card.transcription = transcription
        card.croppedImage = croppedImageData
        card.image = imageData
        sources.forEach {
            card.addToSources($0)
            $0.addToCards(card)
        }
        card.cardStatus = 0
        card.id = UUID()
        card.additionTime = additionDate
        
        var tag: CardArchiveTag?
        
        do {
            if let archiveTag = try ArchiveTagService.shared.getArchiveTag(date: additionDate) {
                tag = archiveTag
            }
        } catch {
            throw DataServiceError.saveFailed(description: "Failed to save tag: \(error.localizedDescription)")
        }
        
        do {
            try context.save()
            if let tag {
                tag.addToCards(card)
            }
            
            cards.append(card)
            if incrementAddedItemsCounter { StatDataService.shared.incrementAddedItemsCounter() }
        } catch {
            context.rollback()
            throw DataServiceError.saveFailed(description: "Failed to save card: \(error.localizedDescription)")
        }
    }
    
    func editCard(
        card: Card,
        phraseToRemember: AttributedString,
        translation: AttributedString? = nil,
        transcription: String? = nil,
        imageData: Data? = nil,
        croppedImageData: Data? = nil,
        sources: [CardSource]
    ) throws {
        let context = dataController.container.viewContext
        
        card.phraseToRemember = NSAttributedString(phraseToRemember)
        if let translation {
            card.translation = NSAttributedString(translation)
        }
        card.transcription = transcription
        card.image = imageData
        card.croppedImage = croppedImageData
        card.sources = nil
        sources.forEach {
            card.addToSources($0)
            $0.addToCards(card)
        }
        
        do {
            try context.save()
            if let index = cards.firstIndex(where: { $0.id == card.id }) { cards[index] = card }
        } catch {
            context.rollback()
            throw DataServiceError.saveFailed(description: "Failed to save card: \(error.localizedDescription)")
        }
    }
    
    func incrementCounter(card: Card) throws {
        let context = dataController.container.viewContext
        
        context.performAndWait {
            card.repetitionCounter += 1
            card.lastRepetition = Date()
            
            do {
                try context.save()
                if let index = cards.firstIndex(where: { $0.id == card.id }) {
                    DispatchQueue.main.async {
                        self.cards[index].repetitionCounter = card.repetitionCounter
                        self.cards[index].lastRepetition = card.lastRepetition
                    }
                }
                StatDataService.shared.incrementRepeatedItemsCounter()
            } catch {
                context.rollback()
                print("Failed to save card: \(error.localizedDescription)")
            }
        }
    }
    
    func setNewStatus(card: Card) {
        card.cardStatus = card.getNewStatus.rawValue
        
        do {
            try dataController.container.viewContext.save()
            if let index = cards.firstIndex(where: { $0.id == card.id }) { cards[index] = card }
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func delete(card: Card) throws {
        let context = dataController.container.viewContext
        context.delete(card)

        do {
            try context.save()
            if let index = cards.firstIndex(where: { $0.id == card.id }) { cards.remove(at: index) }
            StatDataService.shared.incrementDeletedItemsCounter()
        } catch {
            context.rollback()
            throw DataServiceError.saveFailed(description: "Failed to delete card: \(error.localizedDescription)")
        }
    }
    
    func backToInput(card: Card) throws {
        let context = dataController.container.viewContext
        card.cardStatus = 0
        card.isArchived = false
        card.additionTime = Date()
        card.lastRepetition = nil
        card.lastTimeStatusChanged = nil
        
        do {
            try context.save()
            if let index = cards.firstIndex(where: { $0.id == card.id }) { cards[index] = card }
        } catch {
            context.rollback()
            throw DataServiceError.saveFailed(description: "Failed to save context: \(error.localizedDescription)")
        }
    }
}
