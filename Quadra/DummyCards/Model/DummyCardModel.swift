//
//  DummyCardModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 08/05/2024.
//

import Foundation

struct DummyCardModel {
    let item: DummyItem
}

// MARK: - Identifiable
extension DummyCardModel: Identifiable {
    var id: UUID { item.id }
}

// MARK: - Equatable
extension DummyCardModel: Equatable {
    static func == (lhs: DummyCardModel, rhs: DummyCardModel) -> Bool {
        lhs.id == rhs.id
    }
}
