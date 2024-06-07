//
//  CardsViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 22/05/2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class CardsViewModel: ObservableObject {
    @Published var visibleCardModels = [CardModel]()
    @Published var showConfetti = false
    @Published var swipeAction: SwipeAction?
    @Published var showInfoView = false
    @Published var isLoading = false
    
    var cardModels = [CardModel]()
    
    private let visibleCardCount = 5
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        Task {
            await self.updateCards()
        }
        observeCardChanges()
    }
    
    func observeCardChanges() {
        CardService.shared.$cards
            .sink { [weak self] _ in
                Task {
                    await self?.updateCards()
                }
            }
            .store(in: &cancellables)
    }
    
    func updateCards() async {
        isLoading = true
        
        await Task.detached {
            let filteredCards = CardService.shared.cards
                .filter { $0.isReadyToRepeat }
                .map { CardModel(card: $0, mode: .repetition) }
            
            await MainActor.run {
                self.cardModels = filteredCards
                self.showInfoView = self.cardModels.isEmpty
                self.loadVisibleCards()
                self.showConfetti = false
            }
        }.value
        
        try? await Task.sleep(for: .milliseconds(240))
        
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
        StatDataService.shared.incrementRepeatedItemsCounter()
        
        if visibleCardModels.count < visibleCardCount {
            loadVisibleCards()
        }
        
        showConfetti = cardModels.isEmpty
        showInfoView = cardModels.isEmpty
    }
}
