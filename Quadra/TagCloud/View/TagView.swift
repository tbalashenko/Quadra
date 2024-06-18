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
    var action: (() -> Void)?
    
    var body: some View {
        Text(item.title)
            .font(.caption)
            .foregroundColor(foregroundColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .lineLimit(1)
            .background(item.isSelected ? Color(hex: item.color) : Color.offWhiteGray)
            .clipShape(RoundedRectangle(cornerRadius: SizeConstants.cornerRadius))
            .onTapGesture {
                action?()
                item.action?()
            }
    }
}

#Preview {
    TagView(item: MockData.tagCloudItems.first!)
}
