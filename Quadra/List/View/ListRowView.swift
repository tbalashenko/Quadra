//
//  ListRowView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 27/03/2024.
//

import SwiftUI

struct ListRowView: View {
    @EnvironmentObject var cardModel: CardModel
    @State private var offset: CGFloat = -SizeConstants.screenWidth / 2
    @State private var lastOffset: CGFloat = .zero
    @State private var imageSize: CGSize = SizeConstants.listImageSize
    @State private var isMaxImageSize: Bool = false

    var body: some View {
        ZStack {
            cardModel.card.convertedCroppedImage?
                .resizable()
                .scaledToFill()
                .frame(size: imageSize)
                .clipShape(RoundedRectangle(cornerRadius: SizeConstants.cornerRadius))
                .offset(x: offset)
                .if(isMaxImageSize) { $0.northWestShadow() }
                .gesture(dragGesture)
                .overlay(alignment: isMaxImageSize ? .leading : .trailing) {
                    overlayImage
                }
            
            if !isMaxImageSize {
                content
            }
        }
        .frame(height: imageSize.height)
        .if(!isMaxImageSize) { content in
            content.background {
                Color.element
                    .clipShape(RoundedRectangle(cornerRadius: SizeConstants.cornerRadius))
                    .northWestShadow()
            }
        }
        .background {
            NavigationLink(
                "",
                destination: CardView {
                    withAnimation {
                        cardModel.backToInput()
                    }
                }
                    .environmentObject(cardModel)
                    .toolbarTitleDisplayMode(.inline)
                    .toolbar(.hidden, for: .tabBar)
            )
            .opacity(0)
        }
    }
    
    private var overlayImage: some View {
        let color = cardModel.card.isImageDark ?? false ? Color.pureWhite : Color.pureBlack
        return Image(systemName: isMaxImageSize ? "arrow.left.to.line.compact" : "arrow.right.to.line.compact")
            .smallButtonImage()
            .foregroundColor(color)
            .offset(x: offset)
            .opacity(0.5)
            .padding(4)
    }
    
    private var content: some View {
        HStack {
            Spacer()
                .frame(width: cardModel.card.convertedCroppedImage != nil ? SizeConstants.listImageSize.width / 2 - 16 : 0)
            Text(cardModel.card.convertedPhraseToRemember)
                .font(.system(size: 14))
                .multilineTextAlignment(.leading)
                .padding()
            Spacer()
        }
    }
}

extension ListRowView {
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                handleDragChanged(value: value)
            }
            .onEnded { value in
                handleDragEnded(value: value)
            }
    }
    
    private func handleDragChanged(value: DragGesture.Value) {
        if value.translation.width > 0, isMaxImageSize {
            self.offset = lastOffset
        }
    }
    
    private func handleDragEnded(value: DragGesture.Value) {
        if !isMaxImageSize, value.translation.width > 0 {
            withAnimation(.bouncy(duration: 2)) {
                offset = .zero
                imageSize = SizeConstants.listImageFullSize
                isMaxImageSize = true
            }
        } else if isMaxImageSize, value.translation.width < 0 {
            withAnimation(.bouncy(duration: 2)) {
                offset = -SizeConstants.screenWidth / 2
                imageSize = SizeConstants.listImageSize
                isMaxImageSize = false
            }
        }
        haptic(.medium)
        lastOffset = offset
    }
}
