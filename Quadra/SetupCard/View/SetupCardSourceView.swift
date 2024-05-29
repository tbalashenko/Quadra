//
//  SourceSetupCardView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 27/05/2024.
//

import SwiftUI

struct SetupCardSourceView: View {
    @ObservedObject var viewModel: SetupCardViewModel
    @StateObject var tagCloudViewModel: TagCloudViewModel
    @State private var totalHeight: CGFloat = CGFloat.infinity
    
    init(viewModel: SetupCardViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self._tagCloudViewModel = StateObject(wrappedValue: TagCloudViewModel(items: viewModel.tagCloudItems, isSelectable: true, max: 10))
    }
    
    var body: some View {
        GroupBox(TextConstants.sources) {
            AddNewSourceView(viewModel: viewModel)
            TagCloudView(
                viewModel: tagCloudViewModel,
                totalHeight: $totalHeight)
            
        }
        .applyFormStyle()
        .onReceive(viewModel.$tagCloudItems) { newItems in
            tagCloudViewModel.items = newItems
        }
    }
}

//#Preview {
//    SetupCardSourceView()
//}
