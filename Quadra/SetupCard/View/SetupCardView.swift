//
//  SetupCardView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/03/2024.
//

import SwiftUI

struct SetupCardView: View {
    @StateObject var viewModel: SetupCardViewModel
    @Binding var showSetupCardView: Bool

    @State private var showAlert = false
    @State var showPopup: Bool = false

    var body: some View {
        ScrollView {
            PhotoPickerView(image: $viewModel.image, croppedImage: $viewModel.croppedImage)
                .frame(size: SizeConstants.imageSize)
            SetupCardPhraseView(viewModel: viewModel, showPastedPopup: $showPopup)
            SetupCardSourceView(viewModel: viewModel)
        }
        .background {
            Color.element
                .ignoresSafeArea()
        }
        .interactiveDismissDisabled(true)
        .alert(
            TextConstants.warning,
            isPresented: $showAlert,
            actions: {
                Button(TextConstants.yes) { showSetupCardView = false }
                Button(TextConstants.no, role: .cancel) { }
            },
            message: { Text(TextConstants.closeWithoutSavingHelp) }
        )
        .popup(isPresented: $showPopup) {
            CustomPopup(
                text: TextConstants.pasted,
                showPopup: $showPopup
            )
        }
        .navigationTitle(viewModel.mode.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(TextConstants.save) {
                    hideKeyboard()
                    viewModel.saveCard()
                    showSetupCardView = false
                }
                .disabled(viewModel.phraseToRemember.characters.isEmpty)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button(TextConstants.cancel) {
                    if viewModel.hasChanged {
                        showAlert = true
                    } else {
                        showSetupCardView = false
                    }
                }
            }
        }
    }
}

// #Preview {
//    CreateCardView(showSetupCardView: .constant(true))
// }
