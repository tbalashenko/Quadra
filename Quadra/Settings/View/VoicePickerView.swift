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
        Picker(TextConstants.voice, selection: $viewModel.selectedVoice) {
            ForEach(Voice.allVoices.sorted(by: { $0.language < $1.language }), id: \.self) { voice in
                Text(voice.language) + Text(" - ") + Text(voice.name)
            }
        }
        .pickerStyle(.menu)
        LabeledContent(TextConstants.sampleText) {
            HStack {
                Text(viewModel.selectedVoice.samplePhrase)
                TextToSpeechPlayView(
                    viewModel: TextToSpeechViewModel(
                        text: viewModel.selectedVoice.samplePhrase,
                        voice: viewModel.selectedVoice
                    )
                )
            }
        }
    }
}

#Preview {
    VoicePickerView(viewModel: SettingsViewModel())
}
