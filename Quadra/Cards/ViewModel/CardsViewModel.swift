//
//  CardsViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 22/05/2024.
//

import Foundation

final class CardsViewModel: ObservableObject {
    @Published var visibleCardModels = [CardModel]()
    @Published var showConfetti = false
    @Published var swipeAction: SwipeAction?
    @Published var showInfoView = false
    @Published var isLoading = false
    
    var cardModels = [CardModel]()
    let settingsManager = SettingsManager.shared
    let statDataService = StatDataService.shared
    
    private let visibleCardCount = 5
    
    init() {
        updateCards()
    }
    
    func updateCards() {
        isLoading = true
        
        let filteredCards = CardService.shared.cards
            .filter { $0.isReadyToRepeat }
            .map { CardModel(card: $0, mode: .repetition) }
        
        DispatchQueue.main.async {
            self.cardModels = filteredCards
            self.showInfoView = self.cardModels.isEmpty
            self.loadVisibleCards()
            self.isLoading = false
            self.showConfetti = false
        }
    }
    
    func loadVisibleCards() {
        self.visibleCardModels = Array(cardModels.prefix(visibleCardCount).reversed())
    }
    
    func removeCard(model: CardModel, changeStatus: Bool = false) {
        if changeStatus {
            model.changeStatus()
            swipeAction = .left
        }
        
        cardModels.removeAll { $0.id == model.id }
        visibleCardModels.removeAll { $0.id == model.id }
        try? CardService.shared.incrementCounter(card: model.card)
        statDataService.incrementRepeatedItemsCounter()
        
        if visibleCardModels.count < visibleCardCount {
            loadVisibleCards()
        }
        
        showConfetti = cardModels.isEmpty
        showInfoView = cardModels.isEmpty
        if cardModels.isEmpty {
            CardService.shared.updateCards()
        }
    }
    
    func getEmptyCardModel() -> CardModel? {
        do {
            let card = try CardService.shared.saveEmptyCard()
            return CardModel(card: card, mode: .repetition)
        } catch {
            print("Error saving new card: \(error.localizedDescription)")
            return nil
        }
    }
}
