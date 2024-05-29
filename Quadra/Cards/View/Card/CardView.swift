//
//  CardView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/03/2024.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var viewModel: CardsViewModel
    
    @State private var xOffset: CGFloat = .zero
    @State private var yOffset: CGFloat = .zero
    @State private var degrees: Double = 0
    @State private var showSetupCardView = false
    
    @ObservedObject var model: CardModel
    var mode: CardViewMode = .repetition
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                CardHeaderView(viewModel: viewModel, model: model)
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.width * SettingsManager.shared.aspectRatio.ratio)
                FlipablePhraseView(viewModel: PhraseViewModel(model: model))
                if model.showAdditionalInfo {
                    AdditionalnfoView(viewModel: AdditionalnfoViewModel(model: model))
                }
            }
            .background(.element)
            .clipShape(RoundedRectangle(cornerRadius: SizeConstants.cornerRadius))
            .southEastShadow()
            .toolbar {
                if model.canBeChanged {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showSetupCardView = true
                        } label: {
                            Image(systemName: "pencil")
                        }
                    }
                }
            }
            .sheet(isPresented: $showSetupCardView ) {
                NavigationStack {
                    SetupCardView(
                        viewModel: SetupCardViewModel(mode: .edit(model: model)),
                        showSetupCardView: $showSetupCardView)
                }
            }
            .rotationEffect(.degrees(degrees))
            .offset(x: xOffset, y: yOffset)
            .animation(.snappy, value: xOffset)
            .if(mode == .repetition) { content in
                content.gesture(
                    DragGesture(minimumDistance: 20)
                        .onChanged(onDragChanged)
                        .onEnded(onDragEnded)
                )
            }
            .frame(
                width: SizeConstants.cardWith,
                height: SizeConstants.cardHeigh)
            .onReceive(viewModel.$swipeAction, perform: { action in
                if mode == .repetition { onRecieveSwipeAction(action) }
            })
        }
    }
}

private extension CardView {
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
        
        let topCard = $viewModel.cardModels.last
        
        if topCard?.wrappedValue == model {
            switch action {
                case .left:
                    swipeLeft()
                case .right:
                    swipeRight()
            }
        }
    }
}

private extension CardView {
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
