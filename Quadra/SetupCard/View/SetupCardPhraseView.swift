//
//  SetupCardPhraseView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 27/05/2024.
//

import SwiftUI

struct SetupCardPhraseView: View {
    @ObservedObject var viewModel: SetupCardViewModel
    
    var body: some View {
        GroupBox(TextConstants.phraseToRemember) { HighlightableTextView(text: $viewModel.phraseToRemember) }
            .applyFormStyle()
        
        GroupBox(TextConstants.translation) { HighlightableTextView(text: $viewModel.translation) }
            .applyFormStyle()
        
        GroupBox(TextConstants.transcription) {
            TextField(
                "",
                text: $viewModel.transcription,
                axis: .vertical)
            .textFieldStyle(NeuTextFieldStyle(text: $viewModel.transcription))
        }
        .applyFormStyle()
    }
}

//#Preview {
//    SetupCardPhraseView()
//}
