//
//  VoicePickerView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 15/05/2024.
//

import SwiftUI

struct VoicePickerView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Picker("Voice", selection: $viewModel.selectedVoice) {
            ForEach(Voice.allVoices.sorted(by: { $0.language < $1.language }), id: \.self) { voice in
                Text(voice.language) + Text(" - ") + Text(voice.name)
            }
        }
        .pickerStyle(.menu)
        LabeledContent("Sample Text") {
            HStack {
                Text(viewModel.selectedVoice.samplePhrase)
                TextToSpeechPlayView(
                    text: viewModel.selectedVoice.samplePhrase,
                    voice: viewModel.selectedVoice,
                    buttonSize: .small)
            }
        }
    }
}

#Preview {
    VoicePickerView(viewModel: SettingsViewModel())
}
