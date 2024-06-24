//
//  FilterView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 27/03/2024.
//

import SwiftUI
import Combine

struct FilterView: View {
    @StateObject var viewModel: FilterViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        List {
            if !CardService.shared.cards.isEmpty {
                Section(TextConstants.status) {
                    filterTagCloudView(items: viewModel.statusTags)
                        .customListRow()
                }
                
                Section(TextConstants.creationDate) {
                    CreationDateView(viewModel: viewModel)
                        .customListRow()
                }
            }
            
            if !viewModel.archiveTags.isEmpty {
                Section(TextConstants.archiveTags) {
                    filterTagCloudView(items: viewModel.archiveTags)
                        .customListRow()
                }
            }
            
            if !viewModel.sourceTags.isEmpty {
                Section(TextConstants.sources) {
                    filterTagCloudView(items: viewModel.sourceTags)
                        .customListRow()
                }
            }
        }
        .customListStyle()
        .navigationTitle(TextConstants.filter)
        .toolbar {
            Button {
                viewModel.resetFilter()
            } label: {
                Text(TextConstants.reset)
            }
        }
    }
    
    @ViewBuilder
    func filterTagCloudView(items: [TagCloudItem]) -> some View {
        TagCloudView(
            viewModel: TagCloudViewModel(
                items: items,
                isSelectable: true
            )
        )
    }
}
