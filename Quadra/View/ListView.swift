//
//  ListView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    @State private var previousItems: [Item] = []
    
    var body: some View {
        GeometryReader() { geometry in
            NavigationStack {
                List {
                    ForEach(dataManager.items) { item in
                        ListRow(item: item)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.element)
                            .background(
                                NavigationLink("",
                                               destination: CardView(item: item,
                                                                     geometry: geometry,
                                                                     presentationMode: .view)
                                                .environmentObject(dataManager)
                                                .environment(\.managedObjectContext, dataManager.container.viewContext)
                                                .padding(.horizontal, geometry.size.width/12)
                                                .padding(.vertical, geometry.size.width/12)
                                                .background(Color.element))
                                .opacity(0)
                            )
                    }.onDelete(perform: delete)
                }
                .listStyle(.plain)
                .background(Color.element)
                .toolbar {
                    ToolbarItem {
                        Button {
                            filter()
                        } label: {
                            Label("Add Item", systemImage: "line.3.horizontal.decrease.circle.fill")
                        }
                    }
                }
                .onReceive(dataManager.$items) { newItems in
                    if newItems != previousItems {
                        previousItems = newItems
                    }
                }
                .onAppear {
                    print("ListView appeared")
                    dataManager.cleanUp()
                }
                .onDisappear {
                    print("ListView disappeared")
                    dataManager.cleanUp()
                }
            }
        }
    }
    
    func filter() {
        
    }
    
    private func deleteItem(item: Item) {
        dataManager.deleteItem(item)
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            dataManager.deleteItem(dataManager.items[index])
        }
    }
}

#Preview {
    return ListView()
}
