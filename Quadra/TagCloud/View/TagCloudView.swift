//
//  TagCloudView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 19/03/2024.
//

import SwiftUI

struct TagCloudView: View {
    @ObservedObject var viewModel: TagCloudViewModel

    var body: some View {
        ScrollView {
            TagLayout {
                ForEach(viewModel.displayedItems, id: \.id) { item in
                    TagView(item: item) {
                        if viewModel.isSelectable {
                            item.isSelected.toggle()
                            withAnimation {
                                viewModel.updateDisplayedItems()
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TagCloudView(
        viewModel: TagCloudViewModel(
            items: MockData.tagCloudItems,
            isSelectable: true))
}
