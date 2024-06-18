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
                    MoveToButton(model: model, action: action)
                }
            }
            .frame(size: geometry.size)
            .drawingGroup()
        }
    }
}
