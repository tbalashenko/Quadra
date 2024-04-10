//
//  ContentView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI
import CoreData
import SpriteKit

struct ContentView: View {
    @EnvironmentObject var dataManager: CardManager
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
    @State private var showCreateCardView = false
    @State var isLoading: Bool = true
    @State var cardViews: [CardView] = []
    @State var needUpdateView: Bool = false
    @State var showConfetti: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    if settingsManager.showConfetti, showConfetti {
                        ConfettiView(isShown: $showConfetti, timeInS: 4)
                            .ignoresSafeArea()
                    }
                    VStack {
                        if isLoading {
                            SkeletonCardView(aspectRatio: settingsManager.aspectRatio)
                                .padding(geometry.size.width/11)
                        } else {
                            if cardViews.isEmpty {
                                InfoView(needUpdateView: $needUpdateView)
                            } else {
                                SwipeView(cardViews: $cardViews) { moveCard() }
                                    .environmentObject(dataManager)
                                    .environmentObject(settingsManager)
                                    .environment(\.managedObjectContext, viewContext)
                                    .padding(geometry.size.width/11)
                            }
                        }
                        Spacer()
                    }
                }
                .background(Color.element)
                .onAppear {
                    withAnimation {
                        updateCardViews()
                    }
                }
                .onDisappear {
                    cardViews.removeAll()
                    showConfetti = false
                }
                .onChange(of: needUpdateView) { _, _ in
                    if needUpdateView {
                        updateCardViews()
                        needUpdateView = false
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            showCreateCardView = true
                        }) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showCreateCardView, onDismiss:  updateCardViews ) {
                    NavigationStack {
                        CreateCardView(showCreateCardView: $showCreateCardView)
                            .environmentObject(settingsManager)
                    }
                }
            }
        }
    }
    
    func moveCard() {
        guard let removedCard = cardViews.first else { return }
        
        let item = removedCard.item
        dataManager.incrementCounter(for: item)
        cardViews.removeFirst()
        
        if cardViews.isEmpty {
            withAnimation {
                showConfetti = true
            }
        }
    }
    
    func updateCardViews() {
        withAnimation {
            isLoading = true
        }
        cardViews.removeAll()
        
        items
            .reversed()
            .filter { $0.isReadyToRepeat }
            .forEach { item in
                let cardView = CardView(item: item,
                                        cardViewPresentationMode: .swipe,
                                        moveButtonAction: {
                    self.dataManager.setNewStatus(for: item)
                    self.moveCard()
                })
                
                cardViews.append(cardView)
            }
        
        withAnimation {
            isLoading = false
        }
    }
}
