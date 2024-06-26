//
//  TextToSpeechPlayView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 02/04/2024.
//

import SwiftUI

struct TextToSpeechPlayView: View {
    @StateObject var viewModel = TextToSpeechViewModel()
    var buttonSize: Size = .small
    var text: String
    var voice: Voice? = nil

    var body: some View {
        Button(action: {
            viewModel.speak(text: text, voice: voice)
        }, label: {
            Image(systemName: viewModel.isSpeaking ? "stop.circle" : "play.circle")
                .smallButtonImage()
                .foregroundStyle(Color.accentColor)
        })
        .buttonStyle(NeuButtonStyle())
    }
}

extension TextToSpeechPlayView {
    enum Size {
        case small, medium

        var size: CGSize {
            switch self {
                case .small:
                    CGSize(width: 12, height: 12)
                case .medium:
                    CGSize(width: 22, height: 22)
            }
        }
    }
}

#Preview {
    TextToSpeechPlayView(text: "Long, long text")
}
