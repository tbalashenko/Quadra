//
//  SetupCardViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 27/05/2024.
//

import SwiftUI
import Combine

final class SetupCardViewModel: ObservableObject {
    @Published var cardModel: CardModel?
    @Published var tagCloudItems = [TagCloudItem]()
    
    @Published var image: Image?
    @Published var croppedImage: Image?
    @Published var phraseToRemember = AttributedString()
    @Published var translation = AttributedString()
    @Published var transcription = ""
    
    @Published var newSourceText = ""
    
    @Published var selectedSources = [CardSource]()
    let mode: SetupCardViewMode
    private let sourceService = CardSourceService.shared
    private let cardService = CardService.shared
    
    var hasChanged: Bool {
        switch mode {
            case .edit(model: _):
                return phraseToRemember != cardModel?.card.convertedPhraseToRemember
                || translation != cardModel?.card.convertedTranslation
                || transcription != cardModel?.card.transcription
                
            case .create:
                return !String(phraseToRemember.characters).isEmpty
                || !String(translation.characters).isEmpty
                || !transcription.isEmpty
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
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
            image = model.card.convertedImage
            croppedImage = model.card.convertedCroppedImage
        }
        observeNewSourceTextChanges()

    }
    
    func observeNewSourceTextChanges() {
        $newSourceText
            .sink { [weak self] _ in
                self?.updateTagCloudItems()
            }
            .store(in: &cancellables)
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
    }
    
    @MainActor
    func saveCard() {
        let image = image?.convert(scale: SettingsManager.shared.imageScale)
        let croppedImage = croppedImage?.convert(scale: ImageScale.percent100)
        
        switch mode {
            case .create:
                do {
                    try cardService.saveCard(
                        phraseToRemember: phraseToRemember,
                        translation: translation,
                        transcription: transcription,
                        croppedImageData: croppedImage?.pngData(), 
                        imageData: image?.pngData(),
                        sources: selectedSources
                    )
                } catch {
                    print("Error saving card: \(error.localizedDescription)")
                }
            case .edit(_):
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
    
    @MainActor
    func saveSource(color: Color) {
        let hashTagTitle = "#" + newSourceText.replacingOccurrences(of: "#", with: "")
        newSourceText = ""
        
        do {
            let source = try sourceService.saveSource(title: hashTagTitle, color: color.toHex())
            selectedSources.append(source)
            updateTagCloudItems()
        } catch {
            print("Error saving source: \(error.localizedDescription)")
        }
    }
    
    func formatAndSetPhrase(_ text: String, string: inout AttributedString) {
        let updatedAttributes: [NSAttributedString.Key: Any] = [
            .backgroundColor: UIColor.clear,
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.black
        ]
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes(updatedAttributes, range: NSRange(location: 0, length: attributedString.length))
        
        string = AttributedString(attributedString)
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
