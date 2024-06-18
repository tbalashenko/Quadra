//
//  FilterTagCLoudView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 08/06/2024.
//

import SwiftUI

struct FilterTagCloudView: View {
    let title: String
    let items: [TagCloudItem]

    var body: some View {
        GroupBox(title) {
            TagCloudView(
                viewModel: TagCloudViewModel(
                    items: items,
                    isSelectable: true
                )
            )
        }
        .groupBoxStyle(PlainGroupBoxStyle())
    }
}

#Preview {
    FilterTagCloudView(
        title: "Test items",
        items: MockData.tagCloudItems)
}
