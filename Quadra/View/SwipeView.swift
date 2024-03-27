//
//  SwipeView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import CoreData
import SwiftUI

struct SwipeView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var removalTransition = AnyTransition.trailingBottom
    private let dragThreshold: CGFloat = 80.0
    @GestureState private var dragState = DragState.inactive
    @State private var lastIndex = 1
    @State var cardViews: [CardView] = []
    @State private var previousItems: [Item] = []
    @State private var itemToDelete: Item?
    @State var isDisappeared: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    ForEach(cardViews.reversed()) { cardView in
                        cardView
                            .zIndex(self.isTopCard(cardView: cardView) ? 1 : 0) // 1 for top layer.
                            .offset(x: self.isTopCard(cardView: cardView) ? self.dragState.translation.width : 0, y: self.isTopCard(cardView: cardView) ? self.dragState.translation.height : 0)
                            .scaleEffect(self.dragState.isDragging && self.isTopCard(cardView: cardView) ? 0.95 : 1.0)
                            .rotationEffect(Angle(degrees: self.isTopCard(cardView: cardView) ? Double(self.dragState.translation.width / 10) : 0))
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
                                                withAnimation(.interpolatingSpring(stiffness: 180, damping: 100)) {
                                                    self.moveCard()
                                                }
                                            }
                                        }))
                    }
                }
            }
            .onAppear {
                isDisappeared = false
                updateCardViews(geometry: geometry)
            }
            .onDisappear {
                isDisappeared = true
                cardViews.removeAll()
                dataManager.cleanUp()
            }
            .onReceive(dataManager.$items) { newItems in
                if !isDisappeared, newItems != previousItems {
                    previousItems = newItems
                    updateCardViews(geometry: geometry)
                }
            }
        }
    }
    
    func updateCardViews(geometry: GeometryProxy) {
        cardViews.removeAll()
        dataManager.items.forEach { item in
            let cardView = CardView(item: item,
                                    geometry: geometry,
                                    presentationMode: .swipe,
                                    deleteAction: { removeCard() },
                                    moveButtonAction: { dataManager.setNewStatus(for: item) })
            cardViews.append(cardView)
        }
    }
    
    private func isTopCard(cardView: CardView) -> Bool {
        guard let index = cardViews.firstIndex(where: { $0.id == cardView.id }) else {
            return false
        }
        return index == 0
    }
    
    private func moveCard() {
        guard let removedCard = cardViews.first else { return }
        
        let item = removedCard.item
        
        dataManager.incrementCounter(for: item)
        
        cardViews.removeFirst()
    }
    
    private func removeCard() {
        guard let removedCard = cardViews.first else { return }
        
        let item = removedCard.item
        
        dataManager.setMustBeRemoved(item: item)
        
        cardViews.removeFirst()
    }
}
