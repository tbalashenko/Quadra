//
//  CardModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 22/05/2024.
//

import Combine
import SwiftUI

final class CardModel: ObservableObject {
    struct Info: Hashable {
        let description: String
        let value: String
    }
    
    @Published var card: Card
    @Published var showAdditionalInfo: Bool
    @Published var additionalInfo = [Info]()
    @Published var tags = [TagCloudItem]()
    
    private var mode: CardViewMode
    let id = UUID()
    
    var canBeChanged: Bool { mode == .view }
    var showInfoButton: Bool { mode == .repetition }
    var showMoveToButton: Bool { card.needSetNewStatus && mode == .repetition }
    private var cancellables = Set<AnyCancellable>()
    
    init(card: Card, mode: CardViewMode) {
        self.card = card
        self.mode = mode
        showAdditionalInfo = mode == .view
        prepareAdditionalInfo()
        prepareTags()
        observeChanges()
    }
    
    func observeChanges() {
        CardService.shared.cards.first(where: { $0.id == card.id })
            .publisher
            .sink { [weak self] card in
                self?.card = card
                self?.prepareTags()
            }
            .store(in: &cancellables)
    }
    
    func prepareAdditionalInfo() {
        additionalInfo.append(Info(description: TextConstants.added, value: card.additionTime.formatDate()))
        additionalInfo.append(Info(description: TextConstants.numberOfRepetitions, value: String(card.repetitionCounter)))
        
        if let lastRepetition = card.lastRepetition {
            additionalInfo.append(Info(description: TextConstants.lastRepetition, value: lastRepetition.formatDate()))
        }
    }
    
    private func prepareTags() {
        tags.removeAll()
        
        if let tag = prepareArchiveTag() {
            tags.append(tag)
        }
        
        if let tag = prepareStatusTag() {
            tags.append(tag)
        }

        if let tags = prepareSourceTags() {
            self.tags.append(contentsOf: tags)
        }
    }
}

extension CardModel {
    private func prepareArchiveTag() -> TagCloudItem?  {
        guard card.cardStatus == 3, let tag = card.archiveTag else { return nil }
        
        let archiveTag = TagCloudItem(
            isSelected: true,
            id: tag.id,
            title: tag.title,
            color: tag.color)
        
        return archiveTag
    }
    
    private func prepareStatusTag() -> TagCloudItem? {
        guard let status = CardStatus(rawValue: card.cardStatus) else { return nil }
        
        let statusTag = TagCloudItem(
            isSelected: true,
            id: UUID(uuidString: String(status.id)) ?? UUID(),
            title: status.title,
            color: status.color.toHex())
        
        return statusTag
    }
    
    private func prepareSourceTags() -> [TagCloudItem]? {
        guard let sources = card.sources?.allObjects as? [CardSource] else { return nil }
        
        let sourceTags = sources.map {
            TagCloudItem(
                isSelected: true,
                id: $0.id,
                title: $0.title,
                color: $0.color
            )
        }
        
        return sourceTags
    }
}

//final class CardModel: ObservableObject {
//    struct Info: Hashable {
//        let description: String
//        let value: String
//    }
//
//    @Published var card: Card
//    @Published var showAdditionalInfo: Bool
//    @Published var additionalInfo = [Info]()
//    @Published var tags = [TagCloudItem]()
//
//    let id = UUID()
//    var showTranslation: Bool { mode == .view && card.translation != nil }
//    var showMoveToButton: Bool { card.needSetNewStatus && mode == .repetition }
//    var showInfoButton: Bool { mode == .repetition }
//    var canBeChanged: Bool { mode == .view }
//
//    private var mode: CardViewMode
//    private var cancellables = Set<AnyCancellable>()
//
//    init(card: Card, mode: CardViewMode) {
//        self.card = card
//        self.mode = mode
//        showAdditionalInfo = mode == .view
//        prepareAdditionalInfo()
//
//        CardService.shared.cards.first(where: { $0.id == card.id })
//            .publisher
//            .sink { [weak self] card in
//                self?.card = card
//                self?.prepareTags(for: card)
//            }
//            .store(in: &cancellables)
//    }
//
//    func changeStatus() {
//        CardService.shared.setNewStatus(card: card)
//    }
//
//    func prepareAdditionalInfo() {
//        additionalInfo.append(Info(description: TextConstants.added, value: card.additionTime.formatDate()))
//        additionalInfo.append(Info(description: TextConstants.numberOfRepetitions, value: String(card.repetitionCounter)))
//
//        if let lastRepetition = card.lastRepetition {
//            additionalInfo.append(Info(description: TextConstants.lastRepetition, value: lastRepetition.formatDate()))
//        }
//    }
//
//    func prepareTags(for card: Card) {
//        tags.removeAll()
//
//        if card.cardStatus == 3, let tag = card.archiveTag {
//            let archiveTag = TagCloudItem(
//                isSelected: true,
//                id: tag.id,
//                title: tag.title,
//                color: tag.color)
//
//            tags.append(archiveTag)
//        }
//
//        if let status = CardStatus(rawValue: card.cardStatus) {
//            let statusTag = TagCloudItem(
//                isSelected: true,
//                id: UUID(uuidString: String(status.id)) ?? UUID(),
//                title: status.title,
//                color: status.color.toHex())
//
//            tags.append(statusTag)
//        }
//
//        if let sources = Array(arrayLiteral: card.sources) as? [CardSource] {
//            let sourceTags = sources.map {
//                TagCloudItem(
//                    isSelected: true,
//                    id: $0.id,
//                    title: $0.title,
//                    color: $0.color
//                )
//            }
//            tags.append(contentsOf: sourceTags)
//        }
//    }
//}
//
// MARK: - Identifiable
extension CardModel: Identifiable { }

// MARK: - Equatable
extension CardModel: Equatable {
    static func == (lhs: CardModel, rhs: CardModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.card.phraseToRemember == rhs.card.phraseToRemember &&
        lhs.card.translation == rhs.card.translation &&
        lhs.card.transcription == rhs.card.transcription &&
        lhs.card.sources == rhs.card.sources
    }
}
