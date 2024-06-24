//
//  FlipablePhraseView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 23/05/2024.
//

import SwiftUI

struct FlipablePhraseView: View {
    @ObservedObject var model: CardModel
    @State private var showPhraseView = true
    
    var body: some View {
        if showPhraseView {
            PlayableTextView(model: model) {
                if model.card.convertedTranslation != nil {
                    withAnimation {
                        showPhraseView.toggle()
                    }
                }
            }
            .padding(.horizontal)
        } else {
            if let translation = model.card.convertedTranslation {
                Text(translation)
                    .font(.title2)
                    .onTapGesture {
                        withAnimation {
                            showPhraseView.toggle()
                        }
                    }
                    .padding(.horizontal)
            }
        }
    }
}
