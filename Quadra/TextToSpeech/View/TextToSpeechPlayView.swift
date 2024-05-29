//
//  TextToSpeechPlayView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 02/04/2024.
//

import SwiftUI

struct TextToSpeechPlayView: View {
    @StateObject var viewModel: TextToSpeechViewModel
    var buttonSize: TextToSpeechPlayView.size = .small
    
    var body: some View {
        Button(action: {
            viewModel.speak()
        }, label: {
            Image(systemName: viewModel.isSpeaking ? "stop.fill" : "play.fill")
                .resizable()
                .frame(width: buttonSize.width, height: buttonSize.height)
                .foregroundStyle(Color.accentColor)
        })
    }
}

extension TextToSpeechPlayView {
    enum size {
        case small, medium
        
        var width: CGFloat {
            switch self {
                case .small:
                    12
                case .medium:
                    22
            }
        }
        
        var height: CGFloat {
            switch self {
                case .small:
                    12
                case .medium:
                    22
            }
        }
    }
}

#Preview {
    TextToSpeechPlayView(viewModel: TextToSpeechViewModel(text: "Long, Long text"))
}
