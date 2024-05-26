//
//  CardModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 22/05/2024.
//

import Foundation

final class CardModel: ObservableObject {
    @Published var card: Card
    @Published var showAdditionalInfo: Bool
    @Published var showTranslation: Bool
    
    var showMoveToButton: Bool { card.needSetNewStatus && mode == .repetition }
    var showInfoButton: Bool { mode == .repetition }
    var canBeChanged: Bool { mode == .view }
    
    private var mode: CardViewMode
    
    init(card: Card, mode: CardViewMode) {
        self.card = card
        self.mode = mode
        self.showAdditionalInfo = mode == .view
        self.showTranslation = (mode == .view && card.translation != nil)
    }
    
    func changeStatus() {
        CardService.shared.setNewStatus(card: card)
    }
    
}

// MARK: - Identifiable
extension CardModel: Identifiable {
    var id: UUID { card.id }
}

// MARK: - Equatable
extension CardModel: Equatable {
    static func == (lhs: CardModel, rhs: CardModel) -> Bool {
        lhs.id == rhs.id
    }
}
