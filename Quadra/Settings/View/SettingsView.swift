//
//  Settings.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 03/04/2024.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Language and Voice") {
                  VoicePickerView(viewModel: viewModel)
                }
                Section("Images") {
                  ImageSettingsView(viewModel: viewModel)
                }
                Section("Animation") {
                    Toggle("Show Confetti", isOn: $viewModel.showConfetti)
                }
                Section("Manage Sources") {
                    NavigationLink("Sources") {
                        SourcesView()
                    }
                }
                Section("Text Formatting") {
                    HighlighterPaletteView(viewModel: viewModel)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.element)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.save()
                        dismiss()
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationBarTitle("Settings")
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}


