//
//  Settings.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 03/04/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var cardManager: CardManager
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @State var selectedVoice: Voice
    @State var selectedRatio: AspectRatio
    @State var selectedImageScale: ImageScale
    @State var showConfetti: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                languageAndVoiceSection()
                imagesSection()
                animationSection()
                sourcesSection()
            }
            .scrollContentBackground(.hidden)
            .background(Color.element)
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
                selectedImageScale = settingsManager.imageScale
                showConfetti = settingsManager.showConfetti
            }
        }
    }
    
    func languageAndVoiceSection() -> some View {
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
    }
    
    func imagesSection() -> some View {
        Section("Images") {
            Picker("Preferable Aspect Ratio", selection: $selectedRatio) {
                ForEach(AspectRatio.allCases, id: \.self) { ratio in
                    Text(ratio.rawValue)
                }
            }
            .pickerStyle(.menu)
            
            Picker("Preferable Image Quality", selection: $selectedImageScale) {
                ForEach(ImageScale.allCases, id: \.self) { scale in
                    Text(scale.value)
                }
            }
            .pickerStyle(.menu)
            
            Text("Choosing better quality may increase file sizes, consuming more storage space. Lower quality may compromise image readability.")
                .foregroundColor(.secondary)
                .font(.footnote)
        }
    }
    
    func animationSection() -> some View {
        Section("Animation") {
            Toggle("Show confetti", isOn: $showConfetti)
        }
    }
    
    func sourcesSection() -> some View {
        Section("Manage Sources") {
            NavigationLink("Sources") {
                SourcesView()
                    .environmentObject(cardManager)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    func save() {
        settingsManager.save(
            voice: selectedVoice,
            aspectRatio: selectedRatio,
            imageScale: selectedImageScale,
            showConfetti: showConfetti)
        dismiss()
    }
}

//#Preview {
//    SettingsView(selectedVoice: Voice.englishUs0)
//}


