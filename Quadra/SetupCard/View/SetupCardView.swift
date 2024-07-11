//
//  SetupCardView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/03/2024.
//

import SwiftUI

struct SetupCardView: View {
    @ObservedObject var viewModel: SetupCardViewModel
    @Binding var showSetupCardView: Bool
    @State private var showPopup = false
    @State private var showAlert = false
    var onDismiss: ((Bool) -> Void)?
    
    var body: some View {
        List {
            Group {
                PhotoPickerView(viewModel: viewModel)
                imageUrlSection()
                phraseToRememberSection()
                translationSection()
                transcriptionSection()
                sourcesSection()
            }
            .customListRow()
        }
        .interactiveDismissDisabled(true)
        .alert(
            TextConstants.warning,
            isPresented: $showAlert,
            actions: { alertActions() },
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
            ToolbarItem(placement: .confirmationAction) { saveButton() }
            ToolbarItem(placement: .cancellationAction) { cancelButton() }
        }
    }
    
    @ViewBuilder
    private func imageUrlSection() -> some View {
        if viewModel.showImageUrlSection {
            Section(TextConstants.imageUrl) {
                TextFieldWithFlipableButton(
                    text: $viewModel.url,
                    error: viewModel.urlError,
                    additionalButtonImage: Image(systemName: "square.and.arrow.down"),
                    additionalButtonAction: { viewModel.downloadImage() },
                    pasteButtonAction: {
                        viewModel.url = $0
                        showPopup = true
                    }
                )
            }
        }
    }
    
    @ViewBuilder
    private func phraseToRememberSection() -> some View {
        Section(TextConstants.phraseToRemember) {
            HighlightableTextView(text: $viewModel.phraseToRemember, error: viewModel.phraseToRememberError) {
                viewModel.formatAndSetPhrase($0, string: &viewModel.phraseToRemember)
                showPopup = true
            }
        }
    }
    
    @ViewBuilder
    private func translationSection() -> some View {
        Section(TextConstants.translation) {
            HighlightableTextView(text: $viewModel.translation, error: viewModel.translationError) {
                viewModel.formatAndSetPhrase($0, string: &viewModel.translation)
                showPopup = true
            }
        }
    }
    
    @ViewBuilder
    private func transcriptionSection() -> some View {
        Section(TextConstants.transcription) {
            TextFieldWithFlipableButton(
                text: $viewModel.transcription,
                error: viewModel.transcriptionError,
                pasteButtonAction: { text in
                    withAnimation {
                        viewModel.transcription = text
                    }
                    showPopup = true
                }
            )
        }
    }
    
    @ViewBuilder
    private func sourcesSection() -> some View {
        Section(TextConstants.sources) {
            AddNewSourceView(viewModel: viewModel)
            TagCloudView(viewModel: TagCloudViewModel(items: viewModel.tagCloudItems, isSelectable: true))
        }
    }
    
    @ViewBuilder
    private func alertActions() -> some View {
        Button(TextConstants.yes) {
            showSetupCardView = false
            onDismiss?(false)
        }
        Button(TextConstants.no, role: .cancel) { }
    }
    
    @ViewBuilder
    private func saveButton() -> some View {
        Button(TextConstants.save) {
            hideKeyboard()
            viewModel.saveCard()
            showSetupCardView = false
            onDismiss?(true)
        }
        .disabled(viewModel.isSaveButtonDisabled)
    }
    
    @ViewBuilder
    private func cancelButton() -> some View {
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
