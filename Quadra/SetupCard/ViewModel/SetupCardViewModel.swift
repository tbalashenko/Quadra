//
//  SetupCardViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 27/05/2024.
//

import Foundation
import SwiftUI

final class SetupCardViewModel: ObservableObject {
    @Published var cardModel: CardModel?
    @Published var tagCloudItems = [TagCloudItem]()
    
    @Published var phraseToRemember = AttributedString()
    @Published var translation = AttributedString()
    @Published var transcription = ""
    
    @Published var newSourceText = "" {
        didSet { updateTagCloudItems() }
    }
    
    var selectedSources = [CardSource]()
    let mode: SetupCardViewMode
    private let sourceService = CardSourceService.shared
    private let cardService = CardService.shared
    
    var hasChanged: Bool {
        phraseToRemember != cardModel?.card.convertedPhraseToRemember
        || translation != cardModel?.card.convertedTranslation
        || transcription != cardModel?.card.transcription
    }
    
    init(mode: SetupCardViewMode) {
        self.mode = mode
        
        if case .edit(let model) = mode {
            self.cardModel = model
            phraseToRemember = AttributedString(model.card.phraseToRemember)
            translation = AttributedString(model.card.translation ?? NSAttributedString(string: ""))
            transcription = model.card.transcription ?? ""
            if let sources = model.card.sources?.allObjects as? [CardSource] {
                selectedSources = sources
            }
        }
        
        updateTagCloudItems()
    }
    
    func updateTagCloudItems() {
        tagCloudItems = sourceService.sources
            .filter { source in
                if newSourceText.isEmpty {
                    return true
                } else {
                    return source.title.localizedCaseInsensitiveContains(newSourceText)
                }
            }
            .map { source in
                TagCloudItem(
                    isSelected: selectedSources.contains(source),
                    id: source.id,
                    title: source.title,
                    color: source.color
                ) { [weak self] in
                    self?.toggleSourceSelection(source: source)
                }
            }
    }
    
    private func toggleSourceSelection(source: CardSource) {
        if selectedSources.contains(source) {
            selectedSources.removeAll { $0.id == source.id }
        } else {
            selectedSources.append(source)
        }
        updateTagCloudItems()
    }
    
    @MainActor
    func saveCard(image: Image?) {
        let image = image?.convert(scale: SettingsManager.shared.imageScale)
        
        switch mode {
            case .create:
                do {
                    try cardService.saveCard(
                        phraseToRemember: phraseToRemember,
                        translation: translation,
                        transcription: transcription,
                        imageData: image?.pngData(),
                        sources: selectedSources
                    )
                } catch {
                    print("Error saving card: \(error.localizedDescription)")
                }
            case .edit(let model):
                do {
                    guard let cardModel = cardModel else { return }
                    
                    try cardService.editCard(
                        card: cardModel.card,
                        phraseToRemember: phraseToRemember,
                        translation: translation,
                        transcription: transcription,
                        imageData: image?.pngData(),
                        sources: Array(selectedSources)
                    )
                } catch {
                    print("Error editing card: \(error.localizedDescription)")
                }
        }
    }
    
    func saveSource(color: Color) {
        let hashTagTitle = "#" + newSourceText.replacingOccurrences(of: "#", with: "")
        
        do {
            let source = try sourceService.saveSource(title: hashTagTitle, color: color.toHex())
            selectedSources.append(source)
            newSourceText = ""
            updateTagCloudItems()
        } catch {
            print("Error saving source: \(error.localizedDescription)")
        }
    }
}

extension SetupCardViewModel {
    enum SetupCardViewMode {
        case create
        case edit(model: CardModel)
        
        var navigationTitle: String {
            switch self {
                case .create:
                    return "Add a new card"
                case .edit:
                    return "Edit your card"
            }
        }
    }
}
