//
//  ContentView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var id = UUID()
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])  var items: FetchedResults<Item>
    @State var showCreateCardView = false
    
    var body: some View {
        NavigationView {
            SwipeView(items: items)
                .padding(.horizontal)
                .background(Color.element)
                .toolbar {
                    ToolbarItem {
                        Button {
                            showCreateCardView = true
                        } label: {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }.id(id)
                .sheet(isPresented: $showCreateCardView, onDismiss: updateView) {
                    NavigationStack {
                        CreateCardView(showCreateCardView: $showCreateCardView)
                            .environmentObject(manager)
                            .environment(\.managedObjectContext, manager.container.viewContext)
                    }
                }
        }
    }
    
    ///A crutch until update from FetchRequest works in swiftUI, or until I find a solution
    func updateView() {
        id = UUID()
    }
    
    private func deleteItems(offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        //viewModel.delete(index: index)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView()
}
