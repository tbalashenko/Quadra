//
//  AdditionalInfoViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 26/05/2024.
//

import Foundation
import Combine

final class AdditionalnfoViewModel: ObservableObject {
    struct Info: Hashable {
        let description: String
        let value: String
    }
    
    @Published var tags = [TagCloudItem]()
    @Published var transcripton: String = ""
    @Published var showTranscription: Bool = false
    @Published var additionalInfo = [Info]()
    
    private var cardModel: CardModel
    private var cancellables = Set<AnyCancellable>()
    
    init(model: CardModel) {
        self.cardModel = model
        updateProperties(from: model)
        prepareAdditionalInfo(for: model.card)
        setupBindings()
    }
    
    private func setupBindings() {
        cardModel.objectWillChange
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                self.updateProperties(from: self.cardModel)
            }
            .store(in: &cancellables)
    }
    
    private func updateProperties(from model: CardModel) {
        if let transcription = model.card.formattedTranscription {
            self.transcripton = transcription
            showTranscription = true
        }
        prepareTags(for: model.card)
    }
    
    func prepareTags(for card: Card) {
        tags.removeAll()
        
        if card.cardStatus.id == 3, let tag = card.archiveTag {
            let archiveTag = TagCloudItem(
                isSelected: true,
                id: tag.id,
                title: tag.title,
                color: tag.color)
            
            tags.append(archiveTag)
        }
        
        let statusTag = TagCloudItem(
            isSelected: true,
            id: UUID(uuidString: card.cardStatus.title) ?? UUID(),
            title: card.cardStatus.title,
            color: card.cardStatus.color)
        
        tags.append(statusTag)
        
        if let sources = card.sources?.allObjects as? [CardSource] {
            let sourceTags = sources.map {
                TagCloudItem(
                    isSelected: true,
                    id: $0.id,
                    title: $0.title,
                    color: $0.color
                )
            }
            tags.append(contentsOf: sourceTags)
        }
    }
    
    func prepareAdditionalInfo(for card: Card) {
        additionalInfo.append(Info(description: TextConstants.added, value: card.additionTime.formatDate()))
        additionalInfo.append(Info(description: TextConstants.numberOfRepetitions, value: String(card.repetitionCounter)))
        
        if let lastRepetition = card.lastRepetition {
            additionalInfo.append(Info(description: TextConstants.lastRepetition, value: lastRepetition.formatDate()))
        }
    }
}
