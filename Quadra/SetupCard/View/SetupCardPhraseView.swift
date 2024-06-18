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
        GroupBox(TextConstants.phraseToRemember) {
            HStack {
                HighlightableTextView(text: $viewModel.phraseToRemember)
                CopyPasteButton(
                    mode: .paste { viewModel.formatAndSetPhrase($0, string: &viewModel.phraseToRemember) },
                    showPopup: $showPastedPopup
                )
            }
        }
        .groupBoxStyle(PlainGroupBoxStyle())

        GroupBox(TextConstants.translation) {
            HStack {
                HighlightableTextView(text: $viewModel.translation)
                CopyPasteButton(
                    mode: .paste { viewModel.formatAndSetPhrase($0, string: &viewModel.translation) },
                    showPopup: $showPastedPopup
                )
            }
        }
        .groupBoxStyle(PlainGroupBoxStyle())

        GroupBox(TextConstants.transcription) {
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
                CopyPasteButton(
                    mode: .paste { viewModel.transcription = $0 },
                    showPopup: $showPastedPopup
                )
            }
        }
        .groupBoxStyle(PlainGroupBoxStyle())
    }
}
    // #Preview {
    //    SetupCardPhraseView()
    // }
