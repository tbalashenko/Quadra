//
//  SettingsViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 15/05/2024.
//

import Foundation

final class SettingsViewModel: ObservableObject {
    @Published var selectedVoice: Voice
    @Published var selectedRatio: AspectRatio
    @Published var selectedImageScale: ImageScale
    @Published var showConfetti: Bool
    @Published var highlighterPalette: HighlighterPalette
    @Published var showProgress: Bool
    
    let settingsManager = SettingsManager.shared
    
    init() {
        selectedVoice = settingsManager.voice
        selectedRatio = settingsManager.aspectRatio
        selectedImageScale = settingsManager.imageScale
        showConfetti = settingsManager.showConfetti
        highlighterPalette = settingsManager.highliterPalette
        showProgress = settingsManager.showProgress
    }
    
    func save() {
        settingsManager.save(
            voice: selectedVoice,
            aspectRatio: selectedRatio,
            imageScale: selectedImageScale,
            showConfetti: showConfetti,
            highliterPalette: highlighterPalette, 
            showProgress: showProgress)
    }
}
