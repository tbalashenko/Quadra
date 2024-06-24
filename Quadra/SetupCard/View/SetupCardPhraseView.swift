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
                PasteButton { string in
                    Task {
                        await MainActor.run {
                            viewModel.formatAndSetPhrase(string, string: &viewModel.phraseToRemember)
                            showPastedPopup = true
                        }
                    }
                }
            }
        }

        Section(TextConstants.translation) {
            HStack {
                HighlightableTextView(text: $viewModel.translation)
                PasteButton { string in
                    Task {
                        await MainActor.run {
                            viewModel.formatAndSetPhrase(string, string: &viewModel.translation)
                            showPastedPopup = true
                        }
                    }
                }
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
                PasteButton { string in
                    Task {
                        await MainActor.run {
                            viewModel.transcription = string
                            showPastedPopup = true
                        }
                    }
                }
            }
        }
    }
}
    // #Preview {
    //    SetupCardPhraseView()
    // }
