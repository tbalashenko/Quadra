//
//  PhraseViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 26/05/2024.
//

import Foundation

final class PhraseViewModel: ObservableObject {
    @Published var showPhraseView: Bool = true
    @Published var showTranslationView: Bool
    private var flipable: Bool = false
    var translation: AttributedString?
    var phrase: AttributedString
    var textToSpeech: String
    
    init(model: CardModel) {
        showTranslationView = model.showTranslation
        if let translation = model.card.convertedTranslation, !translation.characters.isEmpty {
            self.translation = translation
            self.flipable = !model.showTranslation
        }
        self.phrase = model.card.convertedPhraseToRemember
        self.textToSpeech = model.card.phraseToRemember.string
    }
    
    func switchMode() {
        if flipable {
            showPhraseView.toggle()
            showTranslationView.toggle()
        }
    }
}
