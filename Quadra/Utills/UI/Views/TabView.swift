//
//  TabView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 09/07/2024.
//

import SwiftUI

struct TagView: View {
    var text: String
    var foregroundColor: Color?
    var backgroundColor: Color
    
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .lineLimit(1)
            .foregroundStyle(foregroundColor ?? (backgroundColor.isDark ? .white : .black))
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: SizeConstants.cornerRadius))
    }
}

#Preview {
    TagView(
        text: "Test",
        backgroundColor: Color.catawba
    )
}
