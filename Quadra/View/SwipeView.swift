//
//  SwipeView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI

//
//  SwipeView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI

struct SwipeView: View {
    var items: FetchedResults<Item>
    
    @State private var removalTransition = AnyTransition.trailingBottom
    private let dragThreshold: CGFloat = 80.0
    @GestureState private var dragState = DragState.inactive
    @State private var lastIndex = 1
    @State var cardViews: [CardView] = []
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    ForEach(cardViews) { cardView in
                        cardView
                            .zIndex(self.isTopCard(cardView: cardView) ? 1 : 0) // 1 for top layer.
                            .offset(x: self.isTopCard(cardView: cardView) ? self.dragState.translation.width : 0, y: self.isTopCard(cardView: cardView) ? self.dragState.translation.height : 0)
                            .scaleEffect(self.dragState.isDragging && self.isTopCard(cardView: cardView) ? 0.95 : 1.0)
                            .rotationEffect(Angle(degrees: self.isTopCard(cardView: cardView) ? Double(self.dragState.translation.width / 10) : 0))
                            .animation(.interpolatingSpring(stiffness: 180, damping: 100))
                            .transition(self.removalTransition)
                            .gesture(LongPressGesture(minimumDuration: 0.01)
                                .sequenced(before: DragGesture())
                                .updating(self.$dragState, body: { (value, state, transaction) in
                                    switch value {
                                        case .first(true):
                                            state = .pressing
                                        case .second(true, let drag):
                                            state = .dragging(translation: drag?.translation ?? .zero)
                                        default:
                                            break
                                    }
                                })
                                    .onChanged({ (value) in
                                        guard case .second(true, let drag?) = value else {
                                            return
                                        }
                                        if drag.translation.width < -self.dragThreshold {
                                            self.removalTransition = .leadingBottom
                                        }
                                        
                                        if drag.translation.width > self.dragThreshold {
                                            self.removalTransition = .trailingBottom
                                        }
                                    })
                                     
                                        .onEnded({ (value) in
                                            guard case .second(true, let drag?) = value else {
                                                return
                                            }
                                            if drag.translation.width < -self.dragThreshold || drag.translation.width > self.dragThreshold {
                                                self.moveCard()
                                            }
                                        })
                            )
                    }
                }
            }
            .onAppear() {
                if items.count > 0 {
                    for index in 0...items.count - 1 {
                        cardViews.append(CardView(item: items[index], geometry: geometry))
                    }
                }
            }
        }
        
    }
    
    private func isTopCard(cardView: CardView) -> Bool {
        guard let index = cardViews.firstIndex(where: { $0.id == cardView.id }) else {
            return false
        }
        return index == 0
    }
    
    private func moveCard() {
        let temp = cardViews.removeFirst()
        
        self.lastIndex += 1
        let item = items[lastIndex % items.count]
        
        let newCardView = CardView(item: item, geometry: temp.geometry)
        
        cardViews.append(newCardView)
    }
    
    
}
