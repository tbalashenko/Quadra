//
//  NeuTextFIeldStyle.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 20/03/2024.
//

import SwiftUI

struct NeuTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .lineLimit(5)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(minHeight: 36)
            .background(
                Color.element
                    .shadow(.inner(color: .highlight, radius: 3, x: -3, y: -3))
                    .shadow(.inner(color: .shadow, radius: 3, x: 3, y: 3))
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    VStack {
        Spacer()
        TextField("Test", text: .constant("Test"), axis: .vertical)
            .textFieldStyle(NeuTextFieldStyle())
        TextField("Test", text: .constant("Test"), axis: .vertical)
            .textFieldStyle(NeuTextFieldStyle())
        TextField("Test", text: .constant("Test"))
            .textFieldStyle(NeuTextFieldStyle())
        Spacer()
    }
}

