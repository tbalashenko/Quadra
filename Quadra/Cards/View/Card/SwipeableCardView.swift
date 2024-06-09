//
//  CardView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/03/2024.
//

import SwiftUI

struct SwipeableCardView: View {
    @ObservedObject var viewModel: CardsViewModel
    @ObservedObject var model: CardModel
    
    @State private var xOffset: CGFloat = .zero
    @State private var yOffset: CGFloat = .zero
    @State private var degrees: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            CardView(model: model) {
                viewModel.removeCard(model: model, changeStatus: true)
            }
            .rotationEffect(.degrees(degrees))
            .offset(x: xOffset, y: yOffset)
            .animation(.snappy, value: xOffset)
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onChanged(onDragChanged)
                    .onEnded(onDragEnded)
            )
            .onReceive(viewModel.$swipeAction) { onRecieveSwipeAction($0) }
        }
    }
}

private extension SwipeableCardView {
    private func returnToCenter() {
        xOffset = 0
        yOffset = 0
        degrees = 0
    }
    
    private func swipeRight() {
        withAnimation(.snappy(duration: 1)) {
            xOffset = 500
            degrees = 12
        } completion: {
            viewModel.removeCard(model: model)
        }
    }
    
    private func swipeLeft() {
        withAnimation(.snappy(duration: 1)) {
            xOffset = -500
            degrees = -12
        } completion: {
            viewModel.removeCard(model: model)
        }
    }
    
    private func onRecieveSwipeAction(_ action: SwipeAction?) {
        guard let action = action else { return }
        
        let topCard = viewModel.visibleCardModels.first?.card
        
        if topCard?.id == model.card.id {
            switch action {
                case .left:
                    swipeLeft()
                case .right:
                    swipeRight()
            }
        }
    }
}

private extension SwipeableCardView {
    private func onDragChanged(_ value: _ChangedGesture<DragGesture>.Value) {
        xOffset = value.translation.width
        yOffset = value.translation.height
        degrees = Double(value.translation.width/25)
    }
    
    private func onDragEnded(_ value: _ChangedGesture<DragGesture>.Value) {
        let width = value.translation.width
        if abs(width) <= SizeConstants.screenCutOff {
            returnToCenter()
            return
        }
        
        if width >= SizeConstants.screenCutOff {
            swipeRight()
        } else {
            swipeLeft()
        }
    }
}
