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
    
    @State var image: Image?
    @State var sourceColor = Color.morningBlue
    @State private var isAlertShowing = false
    
    var body: some View {
        List {
            PhotoPickerView(image: $image)
                .styleListSection()
                .frame(
                    width: SizeConstants.photoPickerWidth,
                    height: SizeConstants.photoPickerWidth * SettingsManager.shared.aspectRatio.ratio
                )
            SetupCardPhraseView(viewModel: viewModel)
            SetupCardSourceView(viewModel: viewModel)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.element)
        .interactiveDismissDisabled(true)
        .onAppear { setup() }
        .alert(
            TextConstants.warning,
            isPresented: $isAlertShowing,
            actions: {
                Button(TextConstants.yes) { showSetupCardView = false }
                Button(TextConstants.no, role: .cancel) { }
            },
            message: { Text(TextConstants.closeWithoutSavingHelp) }
        )
        .navigationTitle(viewModel.mode.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(TextConstants.closeWithoutSavingHelp) {
                    hideKeyboard()
                    viewModel.saveCard(image: image)
                    showSetupCardView = false
                }
                .disabled(viewModel.phraseToRemember.characters.isEmpty)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button(TextConstants.cancel) {
                    if viewModel.hasChanged {
                        isAlertShowing = true
                    } else {
                        showSetupCardView = false
                    }
                }
            }
        }
    }
    
    private func setup() {
        if let imageData = viewModel.cardModel?.card.image,
           let uiImage = UIImage(data: imageData) {
            image = Image(uiImage: uiImage)
        }
    }
}

//#Preview {
//    CreateCardView(showSetupCardView: .constant(true))
//}
