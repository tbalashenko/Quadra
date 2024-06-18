//
//  NeuTextFIeldStyle.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 20/03/2024.
//

import SwiftUI

struct NeuTextFieldStyle: TextFieldStyle {
    @Binding var text: String
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            if !text.isEmpty {
                HStack {
                    Spacer()
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .resizable()
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(NeuButtonStyle())
                }
                .padding(.horizontal, 4)
                .zIndex(1)
            }
            configuration
                .lineLimit(5)
                .padding(.leading, 16)
                .padding(.trailing, 32)
                .padding(.vertical, 8)
                .frame(minHeight: 36)
                .background(
                    Color.element
                        .shadow(.inner(color: .highlight, radius: 3, x: -3, y: -3))
                        .shadow(.inner(color: .shadow, radius: 3, x: 3, y: 3))
                )
                .clipShape(RoundedRectangle(cornerRadius: SizeConstants.cornerRadius))
        }
    }
}

#Preview {
    VStack {
        Spacer()
        TextField("Test", text: .constant("Test"), axis: .vertical)
            .textFieldStyle(NeuTextFieldStyle(text: .constant("Test")))
        TextField("Test", text: .constant("Test"), axis: .vertical)
            .textFieldStyle(NeuTextFieldStyle(text: .constant("Test")))
        TextField("Test", text: .constant("Test"))
            .textFieldStyle(NeuTextFieldStyle(text: .constant("Test")))
        Spacer()
    }
}
