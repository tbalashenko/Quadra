//
//  ContentView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var dataManager: CardManager
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
    @State var showCreateCardView = false
    @State var cardViews: [CardView] = []
    @State private var isDisappeared: Bool = true
    @State private var previousItems: [Item] = []
    @State var geometryProxy: GeometryProxy?
    @State var needUpdateView = false

    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack {
                    if cardViews.isEmpty {
                        InfoView(needUpdateView: $needUpdateView)
                    } else {
                        SwipeView(cardViews: $cardViews) { moveCard() }
                            .padding(geometry.size.width/11)
                            .environmentObject(dataManager)
                            .environment(\.managedObjectContext, dataManager.container.viewContext)
                    }
                    Spacer()
                }
                .background(Color.element)
                .onAppear {
                    geometryProxy = geometry
                    isDisappeared = false
                    updateCardViews()
                }
                .onDisappear {
                    isDisappeared = true
                    cardViews.removeAll()
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
                .sheet(isPresented: $showCreateCardView, onDismiss: updateCardViews) {
                    NavigationStack {
                        CreateCardView(showCreateCardView: $showCreateCardView)
                    }
                }
            }
        }
    }

    func updateCardViews() {
        cardViews.removeAll()
        items
            .reversed()
            .filter { $0.isReadyToRepeat }
            .forEach { item in
                if let geometryProxy = geometryProxy {
                    let cardView = CardView(item: item,
                                            geometry: geometryProxy,
                                            presentationMode: .swipe,
                                            moveButtonAction: {
                        dataManager.setNewStatus(for: item)
                        moveCard()
                    })
                    cardViews.append(cardView)
                }
            }
    }

    private func moveCard() {
        guard let removedCard = cardViews.first else { return }

        let item = removedCard.item
        dataManager.incrementCounter(for: item)
        cardViews.removeFirst()
    }
}

#Preview {
    ContentView()
}
