//
//  ContentView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManager
    @State var showCreateCardView = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    EmptyView()
                    SwipeView()
                        .padding(geometry.size.width/11)
                        .background(Color.element)
                        .environmentObject(dataManager)
                        .environment(\.managedObjectContext, dataManager.container.viewContext)
                }
                .toolbar {
                    ToolbarItem {
                        Button {
                            showCreateCardView = true
                        } label: {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                    ToolbarItem {
                        Button {
                            filter()
                        } label: {
                            Label("Add Item", systemImage: "line.3.horizontal.decrease.circle.fill")
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
    
    func filter() {
        
    }
    
    func updateView() {
        //dataManager.update()
    }
}


struct FilterView: View {
    var body: some View {
        Text("")
    }
}


#Preview {
    FilterView()
}

#Preview {
    ContentView()
}
