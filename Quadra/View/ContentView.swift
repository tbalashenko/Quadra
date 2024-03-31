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
    @State var selectedStatuses = Status.allStatuses
    @State var fromDate: Date = Date()
    @State var toDate: Date = Date()
    @State var selectedSources: [Source] = []
    @State var minDate = Date()
    @State private var isFromDateInitialized = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    InfoView()
                    SwipeView(cardViews: $cardViews) { moveCard() }
                        .padding(geometry.size.width/11)
                        .background(Color.element)
                        .environmentObject(dataManager)
                        .environment(\.managedObjectContext, dataManager.container.viewContext)
                        .onAppear {
                            isDisappeared = false
                            updateCardViews(geometry: geometry)
                        }
                        .onDisappear {
                            isDisappeared = true
                            cardViews.removeAll()
                        }
                        .onChange(of: items.map { Array(arrayLiteral: $0) }, { oldValue, newValue in
                            if !isDisappeared {
                                updateCardViews(geometry: geometry)
                            }
                        })
                }
                .onAppear {
                    if !isFromDateInitialized {
                        let minDate = items.map({ $0.additionTime }).min() ?? Date()
                        fromDate = minDate
                        self.minDate = minDate
                        isFromDateInitialized = true
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
                    
                    ToolbarItem {
                        NavigationLink(destination:
                                        FilterView(selectedStatuses: $selectedStatuses,
                                                   fromDate: $fromDate,
                                                   toDate: $toDate,
                                                   selectedSources: $selectedSources,
                                                   minDate: $minDate)
                                            .environmentObject(dataManager)
                                            .environment(\.managedObjectContext, dataManager.container.viewContext)
                                            .toolbar(.hidden, for: .tabBar)) {
                                                Label("Filter", systemImage: "line.3.horizontal.decrease.circle.fill")
                                            }
                    }
                }
                .sheet(isPresented: $showCreateCardView, onDismiss: updateView) {
                    NavigationStack {
                        CreateCardView(showCreateCardView: $showCreateCardView)
                    }
                }
            }
        }
    }
    
    func updateCardViews(geometry: GeometryProxy) {
        cardViews.removeAll()
        items.forEach { item in
            let cardView = CardView(item: item,
                                    geometry: geometry,
                                    presentationMode: .swipe,
                                    deleteAction: { removeCard() },
                                    moveButtonAction: {
                dataManager.setNewStatus(for: item)
                moveCard()
            })
            cardViews.append(cardView)
        }
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
        
        cardViews.removeFirst()
        dataManager.deleteItem(item)
    }
    
    
    func filter() {
        
    }
    
    func updateView() {
        //dataManager.update()
    }
}

#Preview {
    ContentView()
}
