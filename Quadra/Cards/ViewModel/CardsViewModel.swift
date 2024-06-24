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
    @Published var isLoading: Bool = false
    @Published var visibleCardModels = [CardModel]()
    @Published var showConfetti = false
    private var cardModels = [CardModel]()
    
    var showInfoView: Bool = false
    var progress: Double { totalNumberOfCards == 0 ? 0 : Double(cardsShown) / Double(totalNumberOfCards) }
    var progressViewLabel: String { "\(totalNumberOfCards - cardsShown) left" }
    private var totalNumberOfCards = 0
    private let visibleCardCount = 5
    private var cardsShown = 0
    private var cancellables = Set<AnyCancellable>()
    private var nonShownCards = [CardModel]()
    
    init() { }
    
    func clear() {
        nonShownCards = cardModels
        cardModels = []
        visibleCardModels = []
        isLoading = false
    }
    
    func prepareCards(resetNonShownCards: Bool = true) {
        Task {
            withAnimation {
                isLoading = true
            }
            
            let filteredCardModels: [CardModel] = getFilteredCardModels(resetNonShownCards: resetNonShownCards)
            
            cardModels = filteredCardModels
            loadVisibleCards()
            totalNumberOfCards = filteredCardModels.count
            cardsShown = 0
            showInfoView = filteredCardModels.isEmpty
            showConfetti = false
            
            try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
            
            withAnimation {
                isLoading = false
            }
        }
    }
    
    func getFilteredCardModels(resetNonShownCards: Bool) -> [CardModel] {
        var filteredCardModels: [CardModel]
        
        if resetNonShownCards { nonShownCards = [] }
        
        if !nonShownCards.isEmpty {
            filteredCardModels = nonShownCards
                .filter { cardModel in
                    CardService.shared.cards.contains(where: { $0.id == cardModel.card.id })
                }
        } else {
            filteredCardModels = CardService.shared.cards
                .filter { $0.isReadyToRepeat }
                .map { CardModel(card: $0, mode: .repetition) }
        }
        
        return filteredCardModels
    }
    
    

    func loadVisibleCards() {
        self.visibleCardModels = Array(cardModels.prefix(visibleCardCount).reversed())
    }
    
    func removeCard(model: CardModel, changeStatus: Bool = false) {
        if changeStatus {
            CardService.shared.setNewStatus(card: model.card)
        }
        cardModels.removeAll { $0.card.id == model.card.id }
        visibleCardModels.removeAll { $0.card.id == model.card.id }
        
        if visibleCardModels.count < visibleCardCount {
            loadVisibleCards()
        }
        
        cardsShown += 1
        
        showInfoView = cardModels.isEmpty
        showConfetti = cardModels.isEmpty
        
        if showConfetti { hideWithDelay() }
        
        try? CardService.shared.incrementCounter(card: model.card)
        StatDataService.shared.incrementRepeatedItemsCounter()
    }
    
    func hideWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.showConfetti = false
        }
    }
}

//@MainActor
//final class CardsViewModel: ObservableObject {
//    @Published var visibleCardModels = [CardModel]()
//    @Published var showConfetti = false
//    @Published var swipeAction: SwipeAction?
//    @Published var isLoading = false
//
//    private var cardModels = [CardModel]()
//    private let visibleCardCount = 5
//    private var totalNumberOfCards = 0
//    private var cardsShown = 0
//    private var cancellables = Set<AnyCancellable>()
//
//    var showInfoView: Bool { cardModels.isEmpty }
//    var progress: Double {
//        totalNumberOfCards == 0 ? 0 : Double(cardsShown) / Double(totalNumberOfCards)
//    }
//    var progressViewLabel: String {
//        "\(totalNumberOfCards - cardsShown) left"
//    }
//
//    init() {
//        observeCardChanges()
//    }
//
//    func observeCardChanges() {
//        CardService.shared.$cards
//            .sink { [weak self] _ in
//                self?.updateCards()
//            }
//            .store(in: &cancellables)
//    }
//
//    func updateCards() {
//        Task {
//            await MainActor.run {
//                self.isLoading = true
//            }
//
//            let filteredCards = CardService.shared.cards
//                .filter { $0.isReadyToRepeat }
//                .map { CardModel(card: $0, mode: .repetition) }
//
//            await MainActor.run {
//                self.cardModels = filteredCards
//                self.loadVisibleCards()
//                self.showConfetti = false
//                self.totalNumberOfCards = filteredCards.count
//                self.isLoading = false
//            }
//        }
//        self.cardsShown = 0
//    }
//
//    func loadVisibleCards() {
//        self.visibleCardModels = Array(cardModels.prefix(visibleCardCount).reversed())
//    }
//
//    func removeCard(model: CardModel, changeStatus: Bool = false) {
////        Task {
////            await MainActor.run {
//                if changeStatus {
//                    model.changeStatus()
//                }
//                cardModels.removeAll { $0.id == model.id }
//                visibleCardModels.removeAll { $0.id == model.id }
//
//                if visibleCardModels.count < visibleCardCount {
//                    loadVisibleCards()
//                }
//
//                showConfetti = cardModels.isEmpty
//                cardsShown += 1
//           // }
//        //}
//        try? CardService.shared.incrementCounter(card: model.card)
//        StatDataService.shared.incrementRepeatedItemsCounter()
//    }
//}
