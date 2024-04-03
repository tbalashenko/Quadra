//
//  TextToSpeechPlayView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 02/04/2024.
//

import AVFoundation
import SwiftUI


struct TextToSpeechPlayView: View {
    var text: String = ""
    let synthesizer = AVSpeechSynthesizer()
    @State var isSpeaking: Bool = false
    
    var body: some View {
        
        if isSpeaking {
            Button {
                synthesizer.stopSpeaking(at: .immediate)
                isSpeaking = false
            } label: {
                Image(systemName: "stop.fill")
            }
        } else {
            Button {
                let utterance = AVSpeechUtterance(string: text)
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                
                synthesizer.speak(utterance)
                isSpeaking = true
            } label: {
                Image(systemName: "play.fill")
            }
        }
    }
}

#Preview {
    TextToSpeechPlayView(text: "Long, Long text")
}
