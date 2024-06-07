//
//  TagView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 19/03/2024.
//

import SwiftUI

struct TagView: View {
    @ObservedObject var item: TagCloudItem
    var foregroundColor: Color {
        item.isSelected ? (Color(hex: item.color).isDark ? .white : .black) : .black
    }
    var withShadow: Bool = true
    var action: (() -> Void)?
    
    var body: some View {
        Text(item.title)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .lineLimit(1)
            .background(item.isSelected ? Color(hex: item.color) : Color.brightGray)
            .clipShape(RoundedRectangle(cornerRadius: SizeConstants.cornerRadius))
            .foregroundColor(foregroundColor)
            .if(withShadow) { content in
                content.northWestShadow()
            }
            .onTapGesture {
                action?()
                item.action?()
            }
    }
}

#Preview {
    TagView(item: MockData.tagCloudItems.first!)
}
