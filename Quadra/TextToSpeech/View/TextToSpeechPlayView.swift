//
//  TextToSpeechPlayView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 02/04/2024.
//

import SwiftUI

struct TextToSpeechPlayView: View {
    @StateObject var viewModel: TextToSpeechViewModel
    var buttonSize: Size = .small
    
    var body: some View {
        Button(action: {
            viewModel.speak()
        }, label: {
            Image(systemName: viewModel.isSpeaking ? "stop.fill" : "play.fill")
                .resizable()
                .frame(size: buttonSize.size)
                .foregroundStyle(Color.accentColor)
        })
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
    TextToSpeechPlayView(viewModel: TextToSpeechViewModel(text: "Long, Long text"))
}
