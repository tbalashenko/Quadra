//
//  SourcesView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 12/04/2024.
//

import SwiftUI

struct SourcesView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) var sources: FetchedResults<ItemSource>
        
    var body: some View {
        List {
            ForEach(sources, id: \.id) { source in
                SourceListRowView(source: source)
                    .environmentObject(dataController)
                    .environment(\.managedObjectContext, viewContext)
            }
            .onDelete(perform: deleteSources)
        }
        .listStyle(.plain)
        .navigationTitle("Your Sources")
        .scrollContentBackground(.hidden)
        .background(Color.element)
    }
    
    private func deleteSources(offsets: IndexSet) {
        withAnimation {
            offsets
                .map { sources[$0] }
                .forEach { source in
                    viewContext.delete(source)
                    
                    try? viewContext.save()
                }
        }
    }
}

#Preview {
    return SourcesView()
}
