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
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        TextField("", text: $viewModel.searchText, axis: .vertical)
                            .textFieldStyle(NeuTextFieldStyle(text: $viewModel.searchText))
                        Button(
                            action: {
                                viewModel.fetchDefinition()
                            }, label: {
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color.accentColor)
                            }
                        )
                        .buttonStyle(NeuButtonStyle())
                    }
                    Text(TextConstants.enterWord)
                        .foregroundColor(.secondary)
                        .font(.footnote)
                    Divider()
                    if viewModel.showError {
                        Text(TextConstants.noSamplePhrases)
                    }
                }
                .padding(.horizontal, 32)
                ForEach(viewModel.samples, id: \.self) { sampleText in
                    HStack() {
                        Text(sampleText)
                        Spacer()
                        CopyPasteButton(mode: .copy(sampleText), showPopup: $showCopiedPopup)
                    }
                }
                .padding(.horizontal, 32)
            }
            .popup(isPresented: $showCopiedPopup) {
                CustomPopup(
                    text: TextConstants.copied,
                    showPopup: $showCopiedPopup
                )
            }
            .background(Color.element)
            .navigationTitle(TextConstants.getSample)
        }
    }
}

#Preview {
    SamplePhrasesView()
}
