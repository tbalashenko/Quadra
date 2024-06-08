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
                Section(TextConstants.languageAndVoice) {
                  VoicePickerView(viewModel: viewModel)
                }
                Section(TextConstants.images) {
                  ImageSettingsView(viewModel: viewModel)
                }
                Section(TextConstants.animation) {
                    Toggle(TextConstants.showConfetti, isOn: $viewModel.showConfetti)
                }
                Section(TextConstants.manageSources) {
                    NavigationLink(TextConstants.sources) {
                        SourcesView()
                    }
                }
                Section(TextConstants.textFormatting) {
                    HighlighterPaletteView(viewModel: viewModel)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.element)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(TextConstants.save) {
                        viewModel.save()
                        dismiss()
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationBarTitle(TextConstants.settings)
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
}


