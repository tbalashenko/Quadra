//
//  DummyCardService.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 08/05/2024.
//

import Foundation

struct DummyCardService {
    func fetchCardModels() async throws -> [DummyCardModel] {
        let cards = MockData.cards
        return cards.map { DummyCardModel(item: $0) }
    }
}
