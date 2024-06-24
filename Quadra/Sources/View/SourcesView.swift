//
//  SourcesView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 12/04/2024.
//

import SwiftUI

struct SourcesView: View {
    var body: some View {
        List {
            ForEach(CardSourceService.shared.sources, id: \.id) { source in
                SourceListRowView(viewModel: SourceViewModel(source: source))
            }
            .onDelete(perform: deleteSources)
        }
        .customListStyle()
        .navigationTitle(TextConstants.yourSources)
    }

    private func deleteSources(offsets: IndexSet) {
        withAnimation {
            offsets
                .map { CardSourceService.shared.sources[$0] }
                .forEach { try? CardSourceService.shared.deleteSource(source: $0) }
        }
    }
}

#Preview {
    return SourcesView()
}
