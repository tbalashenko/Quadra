//
//  DummyCardsViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 08/05/2024.
//

import Foundation

enum SwipeAction {
    case left, right
}

@MainActor
class DummyCardsViewModel: ObservableObject {
    @Published var cardModels = [DummyCardModel]()
    @Published var swipeAction: SwipeAction?

    private let service = DummyCardService()

    init() {
        Task { await fetchCardModels() }
    }

    func fetchCardModels() async {
        do {
            self.cardModels = try await service.fetchCardModels()
        } catch {
            print("Failed to fetch cards with error \(error)")
        }
    }

    func removeCard(_ card: DummyCardModel) {
        guard let index = cardModels.firstIndex(where: { $0.id == card.id }) else { return }
        cardModels.remove(at: index)
    }

    func timerAction() {
        swipeAction = Bool.random() ? SwipeAction.left : SwipeAction.right
    }

    func updateCardModels() {
        Task { await fetchCardModels() }
    }
}
