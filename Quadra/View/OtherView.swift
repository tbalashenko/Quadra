//
//  OtherView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 03/04/2024.
//

import SwiftUI

struct OtherView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var viewContext
    
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
                    .environmentObject(dataController)
                    .environment(\.managedObjectContext, viewContext)
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
