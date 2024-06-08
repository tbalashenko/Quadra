//
//  SourcesView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 12/04/2024.
//

import SwiftUI

struct SourcesView: View {
    @StateObject var viewModel = SourcesViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.sources, id: \.id) { source in
                SourceListRowView(viewModel: SourceViewModel(source: source))
            }
            .onDelete(perform: deleteSources)
        }
        .listStyle(.plain)
        .navigationTitle(TextConstants.yourSources)
        .scrollContentBackground(.hidden)
        .background(Color.element)
    }
    
    private func deleteSources(offsets: IndexSet) {
        withAnimation {
            offsets
                .map { viewModel.sources[$0] }
                .forEach { viewModel.delete(source: $0) }
        }
    }
}

#Preview {
    return SourcesView()
}
