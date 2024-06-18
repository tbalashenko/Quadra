//
//  ImageSettingsView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 15/05/2024.
//

import SwiftUI

struct ImageSettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        Picker(TextConstants.preferableAspectRatio, selection: $viewModel.selectedRatio) {
            ForEach(AspectRatio.allCases, id: \.self) { ratio in
                Text(ratio.rawValue)
            }
        }
        .pickerStyle(.menu)

        Picker(TextConstants.preferableImageQuality, selection: $viewModel.selectedImageScale) {
            ForEach(ImageScale.allCases, id: \.self) { scale in
                Text(scale.value)
            }
        }
        .pickerStyle(.menu)

        Text(TextConstants.preferableImageQualityHelp)
            .foregroundColor(.secondary)
            .font(.footnote)
    }
}

#Preview {
    ImageSettingsView(viewModel: SettingsViewModel())
}
