//
//  AdditionalInfoViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 26/05/2024.
//

import Foundation

final class AdditionalnfoViewModel: ObservableObject {
    struct Info: Hashable {
        let description: String
        let value: String
    }
    
    @Published var tags = [TagCloudViewItem]()
    @Published var transcripton: String = ""
    @Published var showTranscription: Bool = false
    @Published var additionalInfo = [Info]()
    
    init(model: CardModel) {
        if let transcription = model.card.formattedTranscription {
            self.transcripton = transcription
            showTranscription = true
        }
        prepareTags(for: model.card)
        prepareAdditionalInfo(for: model.card)
    }
    
    func prepareTags(for card: Card) {
        if card.status.id == 3, let tag = card.archiveTag {
            tags.append(TagCloudItem(title: tag.title, color: tag.color))
        }
        
        tags.append(TagCloudItem(title: card.status.title, color: card.status.color))
        
        if let sources = card.sources?.allObjects as? [CardSource] {
            tags.append(contentsOf: sources)
        }
    }
    
    func prepareAdditionalInfo(for card: Card) {
        additionalInfo.append(Info(description: "Added:", value: card.additionTime.formatDate()))
        additionalInfo.append(Info(description: "Number of repetitions:", value: String(card.repetitionCounter)))
        
        if let lastRepetition = card.lastRepetition {
            additionalInfo.append(Info(description: "Last repetition:", value: lastRepetition.formatDate()))
        }
    }
}
