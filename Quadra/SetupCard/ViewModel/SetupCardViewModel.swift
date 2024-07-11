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
    
    @Published var image: Image?
    @Published var croppedImage: Image?
    @Published var showImageUrlSection = false
    @Published var phraseToRemember = AttributedString()
    @Published var phraseToRememberError: String = ""
    @Published var translation = AttributedString()
    @Published var translationError: String = ""
    @Published var transcription = ""
    @Published var transcriptionError: String = ""
    @Published var url = ""
    @Published var urlError: String = ""
    @Published var newSourceText = ""
    @Published var selectedSources = [CardSource]()
    @Published var tagCloudItems = [TagCloudItem]()
    
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
                return !phraseToRemember.isEmpty || !translation.isEmpty || !transcription.isEmpty
        }
    }
    
    var isSaveButtonDisabled: Bool {
        phraseToRemember.characters.isEmpty || !translationError.isEmpty && !transcriptionError.isEmpty
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(mode: SetupCardViewMode, cardModel: CardModel? = nil) {
        self.mode = mode
        
        setup(from: cardModel)
        observeNewSourceTextChanges()
        observeLimits()
        observeUrl()
    }
    
    private func setup(from cardModel: CardModel?) {
        guard let cardModel else { return }
        
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
    
    private func observeNewSourceTextChanges() {
        $newSourceText
            .sink { [weak self] _ in
                self?.updateTagCloudItems()
            }
            .store(in: &cancellables)
    }
    
    private func observeLimits() {
        $phraseToRemember
            .sink { [weak self] value in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    withAnimation {
                        Helpers.getErrorMessage(for: value, errorText: &self.phraseToRememberError)
                    }
                }
            }
            .store(in: &cancellables)
        
        $translation
            .sink { [weak self] value in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    withAnimation {
                        Helpers.getErrorMessage(for: value, errorText: &self.translationError)
                    }
                }
            }
            .store(in: &cancellables)
        
        $transcription
            .sink { [weak self] value in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    withAnimation {
                        Helpers.getErrorMessage(for: value, errorText: &self.transcriptionError)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func observeUrl() {
        $url
            .map { $0.count >= 10 ? $0 : "" }
            .sink { [weak self] value in
                guard let self = self else { return }
                
                self.urlError = value.isEmpty ? "" : (NetworkService.shared.isValidUrl(urlString: value) ? "" : TextConstants.invalidUrl)
            }
            .store(in: &cancellables)
    }
    
    private func updateTagCloudItems() {
        tagCloudItems = sourceService.sources
            .filter { newSourceText.isEmpty ? true : $0.title.localizedCaseInsensitiveContains(newSourceText) }
            .map { source in
                TagCloudItem(
                    isSelected: selectedSources.contains(source),
                    id: source.id,
                    title: source.title,
                    hexColor: source.color
                ) { [weak self] in
                    self?.toggleSourceSelection(source: source)
                }
            }
    }
    
    func downloadImage() {
        guard let url = URL(string: url) else { return }
        
        guard NetworkMonitor.shared.isConnected else { urlError = TextConstants.checkInternetConnection; return }
        
        urlError = ""
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        self.urlError = TextConstants.failedToDownloadImage + (error.localizedDescription)
                    case .finished:
                        break
                }
            }, receiveValue: { data in
                guard let uiImage = UIImage(data: data) else {
                    self.urlError = TextConstants.somethingWentWrong
                    print("Failed to create image from data")
                    return
                }
                
                self.image = Image(uiImage: uiImage)
                self.croppedImage = Image(uiImage: uiImage)
            })
            .store(in: &self.cancellables)
    }
    
    private func toggleSourceSelection(source: CardSource) {
        selectedSources.contains(source) ? selectedSources.removeAll { $0.id == source.id } : selectedSources.append(source)
    }
    
    @MainActor
    func saveCard() {
        let image = image?.convert(scale: SettingsService.imageScale)
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
        
        withAnimation {
            string = AttributedString(attributedString)
        }
    }
}

extension SetupCardViewModel {
    enum SetupCardViewMode {
        case create
        case edit
        
        var navigationTitle: String {
            switch self {
                case .create:
                    return TextConstants.addCard
                case .edit:
                    return TextConstants.editCard
            }
        }
    }
}
