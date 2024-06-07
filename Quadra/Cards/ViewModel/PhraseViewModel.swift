//
//  PhraseViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 26/05/2024.
//

import Foundation
import Combine

final class PhraseViewModel: ObservableObject {
    @Published var showPhraseView: Bool = true
    @Published var showTranslationView: Bool
    
    var translation: AttributedString?
    var phrase: AttributedString { cardModel.card.convertedPhraseToRemember }
    var textToSpeech: String { cardModel.card.phraseToRemember.string }
    
    private var cardModel: CardModel
    private var cancellables = Set<AnyCancellable>()
    private var flipable: Bool = false
    
    init(cardModel: CardModel) {
        self.cardModel = cardModel
        
        self.showTranslationView = cardModel.showTranslation
        if let translation = cardModel.card.convertedTranslation, !translation.characters.isEmpty {
            self.translation = translation
            self.flipable = !cardModel.showTranslation
        }
        self.setupBindings()
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
        self.showTranslationView = cardModel.showTranslation
        if let translation = model.card.convertedTranslation, !translation.characters.isEmpty {
            self.translation = translation
            self.flipable = !model.showTranslation
        }
    }
    
    func switchMode() {
        if flipable {
            showPhraseView.toggle()
            showTranslationView.toggle()
        }
    }
}
