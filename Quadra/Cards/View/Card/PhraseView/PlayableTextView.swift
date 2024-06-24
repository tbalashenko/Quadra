//
//  PlayableTextView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 30/05/2024.
//

import SwiftUI

struct PlayableTextView: View {
    @ObservedObject var model: CardModel
    var action: (() -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            TextToSpeechPlayView(viewModel: TextToSpeechViewModel(text: model.card.stringPhraseToRemember))
            Text(model.card.convertedPhraseToRemember)
                .font(.title2)
                .bold()
                .onTapGesture {
                    action?()
                }
        }
    }
}

// #Preview {
//    PlayableTextView()
// }
