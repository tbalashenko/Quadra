//
//  PlayableTextView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 30/05/2024.
//

import SwiftUI

struct PlayableTextView: View {
    @ObservedObject var viewModel: PhraseViewModel

    var body: some View {
        HStack(spacing: 12) {
            TextToSpeechPlayView(viewModel: TextToSpeechViewModel(text: viewModel.textToSpeech))
            Text(viewModel.phrase)
                .font(.title2)
                .bold()
                .onTapGesture {
                    viewModel.switchMode()
                }
        }
        .padding(.horizontal)
    }
}

// #Preview {
//    PlayableTextView()
// }
