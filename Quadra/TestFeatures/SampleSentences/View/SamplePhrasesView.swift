//
//  SamplePhrasesView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 10/06/2024.
//

import SwiftUI

struct SamplePhrasesView: View {
    @StateObject var viewModel = SamplePhrasesViewModel()
    @State private var showCopiedPopup = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading) {
                        TextFieldWithFlipableButton(
                            text: $viewModel.searchText,
                            error: viewModel.searchTextError,
                            additionalButtonImage: Image(systemName: "magnifyingglass.circle.fill"),
                            additionalButtonAction: { viewModel.fetchDefinition() },
                            pasteButtonAction: {
                                viewModel.searchText = $0
                                showCopiedPopup = true
                            }
                        )
                        Text(TextConstants.enterWord)
                            .foregroundColor(.secondary)
                            .font(.footnote)
                        Divider()
                        if viewModel.showError {
                            Text(TextConstants.noSamplePhrases)
                        }
                    }
                    ForEach(viewModel.samples, id: \.self) { sampleText in
                        HStack {
                            Text(sampleText)
                            Spacer()
                            CopyButton(text: sampleText) {
                                showCopiedPopup = true
                            }
                        }
                    }
                }
                .customListRow()
            }
            .customListStyle()
            .popup(isPresented: $showCopiedPopup) {
                CustomPopup(
                    text: TextConstants.copied,
                    showPopup: $showCopiedPopup
                )
            }
            .navigationTitle(TextConstants.getSample)
        }
        
    }
}

#Preview {
    SamplePhrasesView()
}
