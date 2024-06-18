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
        CardView(model: model) {
            swipeLeft(changeStatus: true)
        }
        .rotationEffect(.degrees(degrees))
        .offset(x: xOffset, y: yOffset)
        .animation(.snappy, value: xOffset)
        .animation(.snappy, value: yOffset)
        .gesture(
            DragGesture(minimumDistance: 20)
                .onChanged(onDragChanged)
                .onEnded(onDragEnded)
        )
    }
}

private extension SwipeableCardView {
    private func returnToCenter() {
        xOffset = 0
        yOffset = 0
        degrees = 0
    }
    
    private func swipeRight(changeStatus: Bool = false) {
        withAnimation(.snappy(duration: 1)) {
            xOffset = 500
            degrees = 12
        } completion: {
            viewModel.removeCard(model: model, changeStatus: changeStatus)
        }
    }
    
    private func swipeLeft(changeStatus: Bool = false) {
        withAnimation(.snappy(duration: 1)) {
            xOffset = -500
            degrees = -12
        } completion: {
            viewModel.removeCard(model: model, changeStatus: changeStatus)
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
