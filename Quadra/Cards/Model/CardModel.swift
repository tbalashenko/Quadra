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
    var showBackToInputButton: Bool { mode == .view && card.cardStatus == 3 }
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
        CardService.shared.$cards
            .sink { [weak self] cards in
                guard let self = self else { return }
                
                if let updatedCard = cards.first(where: { $0.id == self.card.id }) {
                    DispatchQueue.main.async {
                        self.card = updatedCard
                        self.prepareTags()
                    }
                }
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
    
    func backToInput() {
        try? CardService.shared.backToInput(card: card)
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
            hexColor: tag.color
        )
        
        return archiveTag
    }
    
    private func prepareStatusTag() -> TagCloudItem? {
        guard let status = CardStatus(rawValue: card.cardStatus) else { return nil }
        
        let statusTag = TagCloudItem(
            isSelected: true,
            id: UUID(uuidString: String(status.id)) ?? UUID(),
            title: status.title,
            hexColor: status.color.toHex()
        )
        
        return statusTag
    }
    
    private func prepareSourceTags() -> [TagCloudItem]? {
        guard let sources = card.sources?.allObjects as? [CardSource] else { return nil }
        
        let sourceTags = sources.map {
            TagCloudItem(
                isSelected: true,
                id: $0.id,
                title: $0.title,
                hexColor: $0.color
            )
        }
        
        return sourceTags
    }
}
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
        lhs.card.sources == rhs.card.sources &&
        lhs.card.cardStatus == rhs.card.cardStatus
    }
}
