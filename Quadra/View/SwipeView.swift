//
//  SwipeView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import CoreData
import SwiftUI

struct SwipeView: View {
    @Binding var cardViews: [CardView]
    var swipeAction: (() -> Void)?
    
    @GestureState private var dragState = DragState.inactive
    private let dragThreshold: CGFloat = 80.0
    
    var body: some View {
        GeometryReader { _ in
            VStack {
                ZStack {
                    ForEach(cardViews.reversed()) { cardView in
                        cardView
                            .zIndex(self.isTopCard(cardView: cardView) ? 1 : 0) // 1 for top layer.
                            .offset(x: self.isTopCard(cardView: cardView) ? self.dragState.translation.width * 2 : 0, y: self.isTopCard(cardView: cardView) ? self.dragState.translation.height : 0)
                            .scaleEffect(self.dragState.isDragging && self.isTopCard(cardView: cardView) ? 0.95 : 1.0)
                            .rotationEffect(Angle(degrees: self.isTopCard(cardView: cardView) ? Double(self.dragState.translation.width / 10) : 0))
                            .gesture(LongPressGesture(minimumDuration: 0.01)
                                .sequenced(before: DragGesture())
                                .updating(self.$dragState, body: { (value, state, _) in
                                    switch value {
                                        case .first(true):
                                            state = .pressing
                                        case .second(true, let drag):
                                            state = .dragging(translation: drag?.translation ?? .zero)
                                        default:
                                            break
                                    }
                                })
                                    .onEnded({ (value) in
                                        guard case .second(true, let drag?) = value else { return }
                                        
                                        if drag.translation.width < -self.dragThreshold || drag.translation.width > self.dragThreshold {
                                            swipeAction?()
                                        }
                                    }))
                    }
                }
            }
        }
    }
    
    private func isTopCard(cardView: CardView) -> Bool {
        guard let index = cardViews.firstIndex(where: { $0.id == cardView.id }) else { return false }
        
        return index == 0
    }
}
