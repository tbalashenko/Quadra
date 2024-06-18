//
//  CardModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 22/05/2024.
//

import Foundation
import Combine
import SwiftUI

final class CardModel: ObservableObject {
    @Published var card: Card
    @Published var showAdditionalInfo: Bool

    let id = UUID()
    var showTranslation: Bool { mode == .view && card.translation != nil }
    var showMoveToButton: Bool { card.needSetNewStatus && mode == .repetition }
    var showInfoButton: Bool { mode == .repetition }
    var canBeChanged: Bool { mode == .view }

    private var mode: CardViewMode
    private var cancellables = Set<AnyCancellable>()

    init(card: Card, mode: CardViewMode) {
        self.card = card
        self.mode = mode
        self.showAdditionalInfo = mode == .view

        CardService.shared.cards.first(where: { $0.id == card.id })
            .publisher
            .sink { card in
                self.card = card
            }
            .store(in: &cancellables)
    }

    func changeStatus() {
        CardService.shared.setNewStatus(card: card)
    }
}

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
