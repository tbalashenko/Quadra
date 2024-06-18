//
//  SourceListRow.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 12/04/2024.
//

import SwiftUI

struct SourceListRowView: View {
    @StateObject var viewModel: SourceViewModel
    @State var isEditing = false

    var body: some View {
        HStack(spacing: 24) {
            ColorPicker("", selection: Binding<Color>(
                get: { Color(hex: viewModel.color) },
                set: {
                    viewModel.color = $0.toHex()
                    viewModel.saveChanges()
                }
            ))
            .frame(size: SizeConstants.smallButtonImageSize)
            .northWestShadow()

            if isEditing {
                HStack(spacing: 12) {
                    TextField("", text: $viewModel.editableTitle)
                        .textFieldStyle(NeuTextFieldStyle(text: $viewModel.editableTitle))

                    Spacer()

                    Button {
                        viewModel.saveChanges()
                        isEditing = false
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundStyle(viewModel.editableTitle.isEmpty ? Color.Green.isabelline : Color.Green.darkSeaGreen)
                    }
                    .buttonStyle(NeuButtonStyle())
                    .disabled(viewModel.editableTitle.isEmpty)

                    Button {
                        isEditing = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .foregroundStyle(Color.puce)
                    }
                    .buttonStyle(NeuButtonStyle())
                }
            } else {
                Text(viewModel.compoundTitle)
                    .onTapGesture { isEditing = true }
                Spacer()
            }

        }
        .padding()
        .background(
            Color.element
            .clipShape(RoundedRectangle(cornerRadius: SizeConstants.cornerRadius))
            .northWestShadow()
        )
        .listRowBackground(Color.element)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    SourceListRowView(viewModel: SourceViewModel(source: CardSource()))
}
