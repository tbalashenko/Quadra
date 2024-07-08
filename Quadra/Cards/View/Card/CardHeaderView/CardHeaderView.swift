//
//  CardHeaderView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 23/05/2024.
//

import SwiftUI

struct CardHeaderView: View {
    @EnvironmentObject var model: CardModel
    var action: (() -> Void)?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let image = model.card.convertedImage, let croppedImage = model.card.convertedCroppedImage {
                    CardHeaderImageView(image: image, croppedImage: croppedImage)
                } else {
                    EmptyView()
                }
                if model.showInfoButton {
                    AlignableTransparentButton(alignment: .topTrailing) {
                        Image(systemName: "info.circle.fill")
                            .smallButtonImage()
                    } action: {
                        model.showAdditionalInfo.toggle()
                    }
                }
                if model.showMoveToButton {
                    MoveToButton(
                        title: model.card.getNewStatus.title,
                        color: model.card.getNewStatus.color,
                        action: action
                    )
                }
                if model.showBackToInputButton {
                    MoveToButton(
                        title: CardStatus.input.title,
                        color: CardStatus.input.color,
                        action: action
                    )
                }
            }
            .frame(size: geometry.size)
            .drawingGroup()
        }
    }
}
