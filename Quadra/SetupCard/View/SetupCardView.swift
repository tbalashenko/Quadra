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
    var onDismiss: ((Bool) -> Void)?
    
    var body: some View {
        List {
            PhotoPickerView(image: $viewModel.image, croppedImage: $viewModel.croppedImage)
                .center()
                .customListRow()
            SetupCardPhraseView(viewModel: viewModel, showPastedPopup: $showPopup)
                .customListRow()
            SetupCardSourceView(viewModel: viewModel)
                .customListRow()
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
                Button(TextConstants.yes) {
                    showSetupCardView = false
                    onDismiss?(false)
                }
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
        .customListStyle()
        .navigationTitle(viewModel.mode.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(TextConstants.save) {
                    hideKeyboard()
                    viewModel.saveCard()
                    showSetupCardView = false
                    onDismiss?(true)
                }
                .disabled(viewModel.phraseToRemember.characters.isEmpty)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button(TextConstants.cancel) {
                    if viewModel.hasChanged {
                        showAlert = true
                    } else {
                        showSetupCardView = false
                        onDismiss?(false)
                    }
                }
            }
        }
    }
}

// #Preview {
//    CreateCardView(showSetupCardView: .constant(true))
// }
