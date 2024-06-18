//
//  HighliterPaletteView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 15/05/2024.
//

import SwiftUI

struct HighlighterPaletteView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        Picker(TextConstants.preferableHighlighterPalette, selection: $viewModel.highlighterPalette) {
            ForEach(HighlighterPalette.allCases, id: \.self) { palette in
                Text(palette.title)
            }
        }
        .pickerStyle(.menu)

        HStack(spacing: 16) {
            Spacer()
            ForEach(viewModel.highlighterPalette.colors, id: \.self) { color in
                Image(systemName: "highlighter")
                    .smallButtonImage()
                    .foregroundColor(Color(color))
            }
            Spacer()
        }
    }
}

#Preview {
    HighlighterPaletteView(viewModel: SettingsViewModel())
}
