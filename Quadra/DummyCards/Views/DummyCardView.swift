//
//  DummyCardView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 08/05/2024.
//

import SwiftUI

enum CardViewMode {
    case repetition, view
}

struct DummyCardView: View {
    @ObservedObject var viewModel: DummyCardsViewModel
    
    @State private var xOffset: CGFloat = .zero
    @State private var yOffset: CGFloat = .zero
    @State private var degrees: Double = 0
    
    let model: DummyCardModel
    var mode: CardViewMode = .repetition
    
    private let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            VStack {
                model.item.image
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.width * AspectRatio.sixteenToNine.ratio)
                    .clipped()
                    
                HStack {
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: geometry.size.width * 0.05,
                               height: geometry.size.width * 0.05)
                    VStack {
                        Text(model.item.title)
                            .font(.system(size: geometry.size.width * 0.08))
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .background(Color.element)
            .clipShape(RoundedRectangle(cornerRadius: SizeConstants.cornerRadius))
            .southEastShadow()
            .rotationEffect(.degrees(degrees))
            .offset(x: xOffset, y: yOffset)
            .animation(.snappy, value: xOffset)
            .if(mode == .repetition) { content in
                content.gesture(
                    DragGesture()
                        .onChanged(onDragChanged)
                        .onEnded(onDragEnded)
                )
            }
            .onReceive(viewModel.$swipeAction, perform: { action in
                if mode == .repetition { onRecieveSwipeAction(action) }
            })
            .onReceive(timer, perform: { _ in
                if mode == .repetition { viewModel.timerAction() }
            })
        }
    }
}

private extension DummyCardView {
    func returnToCenter() {
        xOffset = 0
        yOffset = 0
        degrees = 0
    }
    
    func swipeRight() {
        withAnimation(.snappy(duration: 1)) {
            xOffset = 500
            yOffset = 0
            degrees = 12
        } completion: {
            viewModel.removeCard(model)
        }
    }
    
    func swipeLeft() {
        withAnimation(.snappy(duration: 1)) {
            xOffset = -500
            yOffset = 0
            degrees = -12
        } completion: {
            viewModel.removeCard(model)
        }
    }
    
    func onRecieveSwipeAction(_ action: SwipeAction?) {
        guard let action = action else { return }
        
        let topCard = viewModel.cardModels.last
        
        if topCard == model {
            switch action {
                case .left:
                    swipeLeft()
                case .right:
                    swipeRight()
            }
        }
    }
}

private extension DummyCardView {
    func onDragChanged(_ value: _ChangedGesture<DragGesture>.Value) {
        xOffset = value.translation.width
        yOffset = value.translation.height
        degrees = Double(value.translation.width/25)
    }
    
    func onDragEnded(_ value: _ChangedGesture<DragGesture>.Value) {
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

#Preview {
    DummyCardView(
        viewModel: DummyCardsViewModel(),
        model: DummyCardModel(item: MockData.cards[0]))
    .frame(
        width: SizeConstants.cardWith,
        height: SizeConstants.cardHeigh)
}
