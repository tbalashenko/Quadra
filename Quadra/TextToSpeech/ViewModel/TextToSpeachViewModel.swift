//
//  TextToSpeachViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 09/04/2024.
//

import Foundation
import AVFoundation

class TextToSpeechViewModel: NSObject, ObservableObject {
    @Published var isSpeaking: Bool = false
    private let voice: Voice
    private let text: String
    private let synthesizer = AVSpeechSynthesizer()

    init(text: String, voice: Voice? = nil) {
        self.text = text
        self.voice = voice ?? SettingsManager.shared.voice
    }

    func speak() {
        guard !synthesizer.isSpeaking else {
            stopSpeaking()
            return
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(identifier: voice.identifier)
        synthesizer.delegate = self
        synthesizer.speak(utterance)
        isSpeaking = true
    }

    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension TextToSpeechViewModel: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
}
