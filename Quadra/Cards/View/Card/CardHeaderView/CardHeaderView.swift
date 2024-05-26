//
//  CardHeaderView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 23/05/2024.
//

import SwiftUI

struct CardHeaderView: View {
    @ObservedObject var viewModel: CardsViewModel
    @ObservedObject var model: CardModel
    
    var body: some View {
        GeometryReader { geometry in
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
                    MoveToButton(viewModel: viewModel, model: model)
                }
            }
        }
    }
}
