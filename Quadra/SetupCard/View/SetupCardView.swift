//
//  SetupCardView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/03/2024.
//

import SwiftUI

struct SetupCardView: View {
    @StateObject var viewModel: SetupCardViewModel
    @Binding var showSetupCardView: Bool
    let settingsManager = SettingsManager.shared
    
    @State private var totalHeight: CGFloat = CGFloat.infinity
    @State var image: Image?
    @State var sourceColor = Color.morningBlue
    @State private var dragOffset = CGFloat.zero
    @State private var isAlertShowing = false
    
    var body: some View {
        List {
            PhotoPickerView(image: $image)
                .styleListSection()
                .frame(
                    width: SizeConstants.photoPickerWidth,
                    height: SizeConstants.photoPickerWidth * settingsManager.aspectRatio.ratio)
            
            SetupCardPhraseView(viewModel: viewModel)
            SetupCardSourceView(viewModel: viewModel)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.element)
        .interactiveDismissDisabled(true)
        .onAppear { setup() }
        .alert("Warning", isPresented: $isAlertShowing, actions: {
            Button("Yes") {
                showSetupCardView = false
            }
            Button("No", role: .cancel) { }
        }, message: {
            Text("Are you sure you want to close the window without saving?")
        })
        .navigationTitle(viewModel.mode.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    hideKeyboard()
                    viewModel.saveCard(image: image)
                    showSetupCardView = false
                }
                .disabled(viewModel.phraseToRemember.characters.isEmpty)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    if viewModel.hasChanged {
                        isAlertShowing = true
                    } else {
                        showSetupCardView = false
                    }
                }
            }
        }
    }
    
    private func setup() {
        if let imageData = viewModel.cardModel?.card.image,
           let uiImage = UIImage(data: imageData) {
            image = Image(uiImage: uiImage)
        }
    }
}

//#Preview {
//    CreateCardView(showSetupCardView: .constant(true))
//}
