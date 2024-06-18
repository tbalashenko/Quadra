//
//  FlipablePhraseView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 23/05/2024.
//

import SwiftUI

struct FlipablePhraseView: View {
    @StateObject var viewModel: PhraseViewModel
    
    var body: some View {
        if viewModel.showPhraseView {
            PlayableTextView(viewModel: viewModel)
        } else {
            if viewModel.showTranslationView, let translation = viewModel.translation {
                Text(translation)
                    .font(.title2)
                    .onTapGesture {
                        viewModel.switchMode()
                    }
            }
        }
    }
}
