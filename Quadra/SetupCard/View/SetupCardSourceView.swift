//
//  SourceSetupCardView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 27/05/2024.
//

import SwiftUI

struct SetupCardSourceView: View {
    @ObservedObject var viewModel: SetupCardViewModel

    var body: some View {
        Section(TextConstants.sources) {
            AddNewSourceView(viewModel: viewModel)
            TagCloudView(viewModel: TagCloudViewModel(items: viewModel.tagCloudItems, isSelectable: true))
        }
    }
}

// #Preview {
//    SetupCardSourceView()
// }
