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
            FilterTagCloudView(
                title: TextConstants.status,
                items: viewModel.statusTags
            )
            CreationDateView(viewModel: viewModel)
            FilterTagCloudView(
                title: TextConstants.archiveTags,
                items: viewModel.archiveTags
            )
            FilterTagCloudView(
                title: TextConstants.sources,
                items: viewModel.sourceTags
            )
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.element)
        .navigationTitle(TextConstants.filter)
        .toolbar {
            Button {
                viewModel.resetFilter()
            } label: {
                Text(TextConstants.reset)
            }
        }
    }
}

// #Preview { }
