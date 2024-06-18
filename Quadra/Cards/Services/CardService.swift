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
        card.cardStatus = .input
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
            try dataController.container.viewContext.save()
            if let tag {
                tag.addToCards(card)
            }

            cards.append(card)
            if incrementAddedItemsCounter { StatDataService.shared.incrementAddedItemsCounter() }
        } catch {
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
            try dataController.container.viewContext.save()
            if let index = cards.firstIndex(where: { $0.id == card.id }) { cards[index] = card }
        } catch {
            throw DataServiceError.saveFailed(description: "Failed to save card: \(error.localizedDescription)")
        }
    }

    func incrementCounter(card: Card) throws {
        card.repetitionCounter += 1
        card.lastRepetition = Date()

        do {
            try dataController.container.viewContext.save()
            if let index = cards.firstIndex(where: { $0.id == card.id }) { cards[index] = card }
        } catch {
            throw DataServiceError.saveFailed(description: "Failed to save card: \(error.localizedDescription)")
        }
    }

    func setNewStatus(card: Card) {
        if card.needMoveToThisWeek {
            card.cardStatus = .thisWeek
        } else if card.needMoveToThisMonth {
            card.cardStatus = .thisMonth
        } else if card.needMoveToArchive {
            card.cardStatus = .archive
            card.isArchived = true
        }

        card.lastTimeStatusChanged = Date()

        do {
            try dataController.container.viewContext.save()
            if let index = cards.firstIndex(where: { $0.id == card.id }) { cards[index] = card }
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    func delete(card: Card) throws {
        dataController.container.viewContext.delete(card)
        if let index = cards.firstIndex(where: { $0.id == card.id }) { cards.remove(at: index) }

        do {
            try dataController.container.viewContext.save()

            StatDataService.shared.incrementDeletedItemsCounter()
        } catch {
            throw DataServiceError.saveFailed(description: "Failed to delete card: \(error.localizedDescription)")
        }
    }
}
