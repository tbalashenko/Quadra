//
//  CardsViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 22/05/2024.
//

import Foundation

@MainActor
final class CardsViewModel: ObservableObject {
    @Published var visibleCardModels = [CardModel]()
    @Published var showConfetti = false
    @Published var swipeAction: SwipeAction?
    @Published var showInfoView = false
    @Published var isLoading = false
    
    var cardModels = [CardModel]()
    let settingsManager = SettingsManager.shared
    let statDataService = StatDataService.shared
    let cardService = CardService.shared
    
    private let visibleCardCount = 5
    
    init() {
        Task {
            await self.updateCards()
        }
    }
    
    func updateCards() async {
        isLoading = true
        
        await Task.detached {
            self.cardService.updateCards()
            
            let filteredCards = self.cardService.cards
                .filter { $0.isReadyToRepeat }
                .map { CardModel(card: $0, mode: .repetition) }
            
            await MainActor.run {
                self.cardModels = filteredCards
                self.showInfoView = self.cardModels.isEmpty
                self.loadVisibleCards()
                self.showConfetti = false
            }
        }.value
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isLoading = false
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
}
