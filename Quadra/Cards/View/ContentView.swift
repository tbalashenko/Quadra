//
//  ContentView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI
import CoreData
import SpriteKit

struct ContentView: View {
    @EnvironmentObject var viewModel: CardsViewModel
    @State private var showSetupCardView = false

    var body: some View {
        NavigationStack {
            ZStack {
                CardStackView()
                    .environmentObject(viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.element, ignoresSafeAreaEdges: .all)
                    .toolbar {
                        ToolbarItem {
                            Button(action: {
                                showSetupCardView = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .smallButtonImage()
                                    .foregroundStyle(Color.accentColor)
                            }
                            .buttonStyle(NeuButtonStyle())
                        }
                    }
                    .toolbar {
                        if !viewModel.showInfoView, SettingsService.showProgress {
                            ToolbarItem(placement: .topBarLeading) {
                                ProgressView(
                                    value: viewModel.progress,
                                    label: { Text("") },
                                    currentValueLabel: { Text(viewModel.progressViewLabel) }
                                )
                                .progressViewStyle(.linear)
                                .frame(width: SizeConstants.screenWidth / 2)
                            }
                        }
                    }
                    .sheet(isPresented: $showSetupCardView) {
                        NavigationStack {
                            SetupCardView(
                                viewModel: SetupCardViewModel(mode: .create),
                                showSetupCardView: $showSetupCardView) { cardWasAdded in
                                    if cardWasAdded { viewModel.prepareCards() }
                                }
                        }
                    }
                if viewModel.showInfoView {
                    InfoView { viewModel.prepareCards()  }
                }
            }
            .overlay { SkeletonCardView(isPresented: $viewModel.isLoading) }
            .overlay { ConfettiView(isPresented: $viewModel.showConfetti) }
            .onAppear { viewModel.prepareCards(resetNonShownCards: false) }
            .onDisappear { viewModel.clear() }
        }
    }
}
