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
                .frame(
                    width: SizeConstants.buttonImageHeighWidth,
                    height: SizeConstants.buttonImageHeighWidth
                )
                .northWestShadow()
            
            TextField(TextConstants.addSource, text: $viewModel.newSourceText)
                .textFieldStyle(NeuTextFieldStyle(text: $viewModel.newSourceText))
                .padding(.horizontal)
            Button(action: {
                if !viewModel.newSourceText.isEmpty {
                    hideKeyboard()
                    viewModel.saveSource(color: sourceColor)
                    sourceColor = .morningBlue
                }
            }, label: {
                Image(systemName: "plus")
            })
            .buttonStyle(NeuButtonStyle(width: 38, height: 38))
            .disabled(viewModel.newSourceText.isEmpty)
        }
    }
}

//#Preview {
//    AddNewSourceView()
//}
