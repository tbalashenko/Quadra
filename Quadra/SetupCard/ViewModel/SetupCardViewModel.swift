//
//  SetupCardViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 27/05/2024.
//

import SwiftUI
import Combine

@MainActor
final class SetupCardViewModel: ObservableObject {
    @Published var cardModel: CardModel?
    @Published var tagCloudItems = [TagCloudItem]()
    
    @Published var image: Image?
    @Published var croppedImage: Image?
    @Published var showImageUrlSection = false
    @Published var phraseToRemember = AttributedString()
    @Published var translation = AttributedString()
    @Published var transcription = ""
    @Published var url = ""
    @Published var newSourceText = ""
    
    @Published var selectedSources = [CardSource]()
    let mode: SetupCardViewMode
    private let sourceService = CardSourceService.shared
    private let cardService = CardService.shared
    
    var hasChanged: Bool {
        switch mode {
            case .edit:
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
    
    init(mode: SetupCardViewMode, cardModel: CardModel? = nil) {
        self.mode = mode
        
        if let cardModel {
            self.cardModel = cardModel
            phraseToRemember = cardModel.card.convertedPhraseToRemember
            if let translation = cardModel.card.convertedTranslation {
                self.translation = translation
            }
            transcription = cardModel.card.transcription ?? ""
            if let sources = cardModel.card.sources?.allObjects as? [CardSource] {
                selectedSources = sources
            }
            image = cardModel.card.convertedImage
            croppedImage = cardModel.card.convertedCroppedImage
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
            .filter { newSourceText.isEmpty ? true : $0.title.localizedCaseInsensitiveContains(newSourceText) }
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
    
    func downloadImage() {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        print("Failed to download image: \(error)")
                    case .finished:
                        break
                }
            }, receiveValue: { data in
                guard let uiImage = UIImage(data: data) else {
                    print("Failed to create UIImage from data")
                    return
                }
                
                self.image = Image(uiImage: uiImage)
                self.croppedImage = Image(uiImage: uiImage)
            })
            .store(in: &self.cancellables)
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
            case .edit:
                do {
                    guard let cardModel = cardModel else { return }
                    
                    try cardService.editCard(
                        card: cardModel.card,
                        phraseToRemember: phraseToRemember,
                        translation: translation,
                        transcription: transcription,
                        imageData: image?.pngData(),
                        croppedImageData: croppedImage?.pngData(),
                        sources: Array(selectedSources)
                    )
                } catch {
                    print("Error editing card: \(error.localizedDescription)")
                }
        }
    }
    
    @MainActor
    func saveSource(color: Color) {
        do {
            let source = try sourceService.saveSource(title: newSourceText, color: color.toHex())
            selectedSources.append(source)
            updateTagCloudItems()
            newSourceText = ""
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
        case edit
        
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
