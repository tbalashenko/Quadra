//
//  Settings.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 03/04/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) var dismiss
    @State var selectedVoice: Voice
    @State var selectedRatio: AspectRatio
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Language and Voice") {
                    Picker("Voice", selection: $selectedVoice) {
                        ForEach(Voice.allVoices.sorted(by: { $0.language < $1.language }), id: \.self) { voice in
                            Text(voice.language) + Text(" - ") + Text(voice.name)
                        }
                    }
                    .pickerStyle(.menu)
                    LabeledContent("Sample Text") {
                        HStack {
                            Text(selectedVoice.samplePhrase)
                            TextToSpeechPlayView(
                                text: selectedVoice.samplePhrase,
                                voice: selectedVoice,
                                buttonSize: .small)
                            .environmentObject(settingsManager)
                        }
                    }
                }
                Section("Images") {
                    Picker("Preferable Aspect Ratio", selection: $selectedRatio) {
                        ForEach(AspectRatio.allCases, id: \.self) { ratio in
                            Text(ratio.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationBarTitle("Settings")
            .onAppear() {
                selectedVoice = settingsManager.voice
                selectedRatio = settingsManager.aspectRatio
            }
        }
    }
    
    func save() {
        settingsManager.save(voice: selectedVoice, aspectRatio: selectedRatio)
        dismiss()
    }
}

//#Preview {
//    SettingsView(selectedVoice: Voice.englishUs0)
//}


