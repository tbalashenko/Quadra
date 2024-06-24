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
            ZStack {
                Color.element
                    .ignoresSafeArea()
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
                                        .smallButtonImage()
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
                    .padding(.horizontal, SizeConstants.horizontalPadding)
                    ForEach(viewModel.samples, id: \.self) { sampleText in
                        HStack {
                            Text(sampleText)
                            Spacer()
                            CopyButton(text: sampleText) {
                                showCopiedPopup = true
                            }
                        }
                    }
                    .padding(.horizontal, SizeConstants.horizontalPadding)
                }
                .popup(isPresented: $showCopiedPopup) {
                    CustomPopup(
                        text: TextConstants.copied,
                        showPopup: $showCopiedPopup
                    )
                }
            }
            .navigationTitle(TextConstants.getSample)
        }
    }
}

#Preview {
    SamplePhrasesView()
}
