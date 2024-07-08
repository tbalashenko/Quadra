//
//  TextFieldWithFlipableButton.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 25/06/2024.
//

import SwiftUI

struct TextFieldWithFlipableButton: View {
    @Binding var text: String
    var error: String
    
    var additionalButtonImage: Image? = nil
    var additionalButtonAction: (() -> Void)? = nil
    var pasteButtonAction: ((String) -> Void)?
    
    private var showPasteButton: Bool { 
        text.isEmpty || (additionalButtonAction == nil && additionalButtonImage == nil)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("", text: $text, axis: .vertical)
                    .textFieldStyle(NeuTextFieldStyle(text: $text))
                    .onSubmit { hideKeyboard() }
                    .submitLabel(.done)
                
                if showPasteButton {
                    PasteButton { pasteButtonAction?($0) }
                } else {
                    additionalButton()
                }
            }
            ErrorView(error: error)
        }
    }
    
    @ViewBuilder
    func additionalButton() -> some View {
        if let additionalButtonImage, let additionalButtonAction {
            Button {
                additionalButtonAction()
            } label: {
                additionalButtonImage
                    .smallButtonImage()
                    .foregroundStyle(Color.accentColor)
            }
        }
    }
}

struct ErrorView: View {
    let error: String
    
    var body: some View {
        if !error.isEmpty {
            Text(error)
                .font(.footnote)
                .foregroundStyle(Color.red)
        }
    }
}

//#Preview {
//    TextFieldWithFlipableButton(text: .constant("Test"), showPasteButton: true) { _ in
//        print("pasted")
//    }
//}
