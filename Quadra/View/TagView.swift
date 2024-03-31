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
    var action: (()->())?
    
    private var randomColor: Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
    
    var body: some View {
        Button(action: action ?? {}, label: {
            Text(text)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(backgroundColor ?? randomColor)
                .foregroundColor(foregroundColor)
                .cornerRadius(8)
        })
        .northWestShadow()
    }
}

#Preview {
    TagView(text: "Test", backgroundColor: .catawba)
}
