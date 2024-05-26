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
        Picker("Preferable Aspect Ratio", selection: $viewModel.selectedRatio) {
            ForEach(AspectRatio.allCases, id: \.self) { ratio in
                Text(ratio.rawValue)
            }
        }
        .pickerStyle(.menu)
        
        Picker("Preferable Image Quality", selection: $viewModel.selectedImageScale) {
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

#Preview {
    ImageSettingsView(viewModel: SettingsViewModel())
}
