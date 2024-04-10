//
//  OtherView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 03/04/2024.
//

import SwiftUI

struct OtherView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Settings") {
                    SettingsView(
                        selectedVoice: settingsManager.voice,
                        selectedRatio: settingsManager.aspectRatio,
                        selectedImageScale: settingsManager.imageScale, 
                        showConfetti: settingsManager.showConfetti)
                    .environmentObject(settingsManager)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.element)
            .navigationTitle("Other")
        }
    }
}

#Preview {
    OtherView()
}
