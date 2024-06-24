//
//  SetupCardPhraseView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 27/05/2024.
//

import SwiftUI

struct SetupCardPhraseView: View {
    @ObservedObject var viewModel: SetupCardViewModel
    @Binding var showPastedPopup: Bool

    var body: some View {
        Section(TextConstants.phraseToRemember) {
            HStack {
                HighlightableTextView(text: $viewModel.phraseToRemember)
                PasteButton(payloadType: String.self) { strings in
                    Task {
                        await MainActor.run {
                            viewModel.formatAndSetPhrase(strings, string: &viewModel.phraseToRemember)
                            showPastedPopup = true
                        }
                    }
                }
                .buttonBorderShape(.capsule)
                .labelStyle(.iconOnly)
            }
        }

        Section(TextConstants.translation) {
            HStack {
                HighlightableTextView(text: $viewModel.translation)
                PasteButton(payloadType: String.self) { strings in
                    Task {
                        await MainActor.run {
                            viewModel.formatAndSetPhrase(strings, string: &viewModel.translation)
                            showPastedPopup = true
                        }
                    }
                }
                .buttonBorderShape(.capsule)
                .labelStyle(.iconOnly)
            }
        }

        Section(TextConstants.transcription) {
            HStack {
                TextField(
                    "",
                    text: $viewModel.transcription,
                    axis: .vertical)
                .textFieldStyle(NeuTextFieldStyle(text: $viewModel.transcription))
                .onSubmit {
                    hideKeyboard()
                }
                .submitLabel(.done)
                PasteButton(payloadType: String.self) { strings in
                    Task {
                        await MainActor.run {
                            guard let text = strings.first else { return }
                            
                            viewModel.transcription = text
                            showPastedPopup = true
                        }
                    }
                }
                .buttonBorderShape(.capsule)
                .labelStyle(.iconOnly)
            }
        }
    }
}
    // #Preview {
    //    SetupCardPhraseView()
    // }
