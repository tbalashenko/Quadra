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
    @Published var isLoading = false

    private var cardModels = [CardModel]()
    private let visibleCardCount = 5
    private var totalNumberOfCards = 0
    private var cardsShown = 0
    private var cancellables = Set<AnyCancellable>()

    var showInfoView: Bool { cardModels.isEmpty }
    var progress: Double {
        totalNumberOfCards == 0 ? 0 : Double(cardsShown) / Double(totalNumberOfCards)
    }
    var progressViewLabel: String {
        "\(totalNumberOfCards - cardsShown) left"
    }

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
        if CardService.shared.cards.isEmpty { return }

        await MainActor.run {
            withAnimation {
                self.isLoading = true
            }
        }

        Task.detached {
                    let filteredCards = CardService.shared.cards
                        .filter { $0.isReadyToRepeat }
                        .map { CardModel(card: $0, mode: .repetition) }

                    await MainActor.run {
                        self.cardModels = filteredCards
                        self.loadVisibleCards()
                        self.showConfetti = false
                        self.cardsShown = 0
                        self.totalNumberOfCards = filteredCards.count

                        // Perform loading state change with animation on the main thread
                        withAnimation {
                            self.isLoading = false
                        }
                    }
                }
    }

    func loadVisibleCards() {
        self.visibleCardModels = Array(cardModels.prefix(visibleCardCount).reversed())
    }

    func removeCard(model: CardModel, changeStatus: Bool = false) {
        if changeStatus {
            model.changeStatus()
        }

        cardModels.removeAll { $0.id == model.id }
        visibleCardModels.removeAll { $0.id == model.id }
        try? CardService.shared.incrementCounter(card: model.card)
        StatDataService.shared.incrementRepeatedItemsCounter()

        if visibleCardModels.count < visibleCardCount {
            loadVisibleCards()
        }

        showConfetti = cardModels.isEmpty
        cardsShown += 1
    }
}
