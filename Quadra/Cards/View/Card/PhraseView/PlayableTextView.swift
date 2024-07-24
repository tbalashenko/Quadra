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
        HStack(alignment: .center, spacing: 12) {
            TextToSpeechPlayView(text: model.card.stringPhraseToRemember)
            DynamicHeightScrollView(maxHeight: SizeConstants.cardHeigh/3) {
                Text(model.card.convertedPhraseToRemember)
                    .font(.title2)
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)
                    .onTapGesture {
                        action?()
                    }
            }
        }
    }
}

#Preview {
    PlayableTextView(model: CardModel(card: MockData.cards.first!, mode: .repetition)!)
}
