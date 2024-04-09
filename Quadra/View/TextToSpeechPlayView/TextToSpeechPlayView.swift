//
//  TextToSpeechPlayView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 02/04/2024.
//

import SwiftUI

struct TextToSpeechPlayView: View {
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
    
    var color: Color?
    var text: String
    var voice: Voice?
    var buttonSize: TextToSpeechPlayView.size = .medium
    
    @StateObject var viewModel = TextToSpeechViewModel()
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        Button(action: {
            viewModel.speak(text, voice: voice ?? settingsManager.voice)
        }, label: {
            Image(systemName: viewModel.isSpeaking ? "stop.fill" : "play.fill")
                .resizable()
                .frame(width: buttonSize.width, height: buttonSize.height)
                .foregroundStyle(color ?? Color.accentColor)
        })
    }
}

#Preview {
    TextToSpeechPlayView(text: "Long, Long text")
}
