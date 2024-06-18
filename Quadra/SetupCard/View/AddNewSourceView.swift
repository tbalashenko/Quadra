//
//  AddNewSourceView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 29/05/2024.
//

import SwiftUI

struct AddNewSourceView: View {
    @ObservedObject var viewModel: SetupCardViewModel
    @State private var sourceColor = Color.morningBlue
    
    var body: some View {
        HStack {
            ColorPicker("", selection: $sourceColor)
                .frame(size: SizeConstants.mediumButtonImageSize)
                .northWestShadow()
            
            TextField(TextConstants.addSource, text: $viewModel.newSourceText)
                .textFieldStyle(NeuTextFieldStyle(text: $viewModel.newSourceText))
                .padding(.horizontal, 4)
            Button(action: {
                if !viewModel.newSourceText.isEmpty {
                    viewModel.saveSource(color: sourceColor)
                    hideKeyboard()
                    sourceColor = .morningBlue
                }
            }, label: {
                Image(systemName: "plus")
            })
            .buttonStyle(NeuButtonStyle(size: SizeConstants.mediumButtonImageSize))
            .disabled(viewModel.newSourceText.isEmpty)
        }
    }
}

//#Preview {
//    AddNewSourceView()
//}
