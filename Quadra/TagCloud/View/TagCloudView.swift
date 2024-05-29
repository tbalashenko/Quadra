//
//  TagCloudView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 19/03/2024.
//

import SwiftUI

struct TagCloudView: View {
    @ObservedObject var viewModel: TagCloudViewModel
    @Binding var totalHeight: CGFloat
    
    var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(viewModel.displayedItems) { item in
                    TagView(
                        item: item,
                        isSelectable: viewModel.isSelectable
                    ) {
                        if viewModel.isSelectable {
                            item.isSelected.toggle()
                        }
                        viewModel.updateDisplayedItems()
                    }
                    .padding(4)
                    .alignmentGuide(.leading) { tagSize in
                        if abs(width - tagSize.width) > geometry.size.width {
                            width = 0
                            height -= tagSize.height
                        }
                        let offset = width
                        width = (item == viewModel.displayedItems.last) ? 0 : width - tagSize.width
                        return offset
                    }
                    .alignmentGuide(.top) { _ in
                        let offset = height
                        if item == viewModel.displayedItems.last { height = 0 }
                        return offset
                    }
                }
            }
            .background(viewHeightReader($totalHeight))
        }
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

#Preview {
    TagCloudView(
        viewModel: TagCloudViewModel(
            items: MockData.tagCloudItems,
            isSelectable: true),
        totalHeight: .constant(.infinity))
}
