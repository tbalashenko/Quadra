//
//  TagView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 19/03/2024.
//

import SwiftUI

struct TagView: View {
    let text: String
    let backgroundColor: Color?
    var foregroundColor: Color {
        backgroundColor?.isDark ?? false ? .white : .black
    }
    var withShadow: Bool = true
    var action: (() -> Void)?

    var body: some View {
        Button(
            action: action ?? {},
            label: {
                Text(text)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(backgroundColor ?? Color.randomColor)
                    .foregroundColor(foregroundColor)
                    .cornerRadius(8)
                    .if(withShadow) { content in
                        content.northWestShadow()
                    }
            })
    }
}

#Preview {
    TagView(text: "Test", backgroundColor: .catawba)
}
