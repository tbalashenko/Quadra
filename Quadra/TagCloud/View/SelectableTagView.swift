//
//  TagView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 19/03/2024.
//

import SwiftUI

struct SelectableTagView: View {
    @ObservedObject var item: TagCloudItem
    var foregroundColor: Color {
        item.isSelected ? (item.color.isDark ? .white : .black) : .black
    }
    var action: (() -> Void)?
    
    var body: some View {
        TagView(
            text: item.title,
            foregroundColor: foregroundColor,
            backgroundColor: item.isSelected ? item.color : Color.silverSand
        )
        .onTapGesture {
            action?()
            item.action?()
        }
    }
}

#Preview {
    TagCloudView(viewModel: TagCloudViewModel(items: MockData.tagCloudItems, isSelectable: true))
        .background(Color.element)
}
