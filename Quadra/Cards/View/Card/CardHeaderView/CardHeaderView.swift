//
//  CardHeaderView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 23/05/2024.
//

import SwiftUI

struct CardHeaderView: View {
    @ObservedObject var model: CardModel
    var action: (() -> ())?
    
    var body: some View {
        ZStack {
            if let image = model.card.convertedImage {
                CardHeaderImageView(image: image)
            } else {
                EmptyView()
            }
            if model.showInfoButton {
                InfoButton(model: model)
            }
            if model.showMoveToButton {
                MoveToButton(model: model, action: action)
            }
        }
    }
}
