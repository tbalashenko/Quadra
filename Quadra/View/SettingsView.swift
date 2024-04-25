//
//  Settings.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 03/04/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settingsManager: SettingsManager
    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State var selectedVoice: Voice
    @State var selectedRatio: AspectRatio
    @State var selectedImageScale: ImageScale
    @State var showConfetti: Bool
    @State var highlighterPalette: HighliterPalette = .pale
    
    var body: some View {
        NavigationStack {
            Form {
                languageAndVoiceSection()
                imagesSection()
                animationSection()
                sourcesSection()
                highlighterPaletteSection()
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
                highlighterPalette = settingsManager.highliterPalette
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
            Toggle("Show Confetti", isOn: $showConfetti)
        }
    }
    
    func sourcesSection() -> some View {
        Section("Manage Sources") {
            NavigationLink("Sources") {
                SourcesView()
                    .environmentObject(dataController)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    func highlighterPaletteSection() -> some View {
        Section("Text Formatting") {
            Picker("Preferable Highlighter Palette", selection: $highlighterPalette) {
                ForEach(HighliterPalette.allCases, id: \.self) { palette in
                    Text(palette.title)
                }
            }
            .pickerStyle(.menu)
            
            HStack(spacing: 16) {
                Spacer()
                ForEach(highlighterPalette.colors, id: \.self) { color in
                    Image(systemName: "highlighter")
                        .frame(width: 22, height: 22)
                        .foregroundColor(Color(color))
                }
                Spacer()
            }
        }
    }
    
    func save() {
        settingsManager.save(
            voice: selectedVoice,
            aspectRatio: selectedRatio,
            imageScale: selectedImageScale,
            showConfetti: showConfetti,
            highliterPalette: highlighterPalette)
        dismiss()
    }
}

//#Preview {
//    SettingsView(selectedVoice: Voice.englishUs0)
//}


