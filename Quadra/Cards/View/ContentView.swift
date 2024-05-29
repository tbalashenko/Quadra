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
    @StateObject var viewModel = CardsViewModel()
    
    @State private var showSetupCardView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                CardStackView(viewModel: viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.element, ignoresSafeAreaEdges: .all)
                    .toolbar {
                        ToolbarItem {
                            Button(action: {
                                showSetupCardView = true
                            }) {
                                Label("Add Item", systemImage: "plus.circle.fill")
                            }
                        }
                    }
                    .sheet(isPresented: $showSetupCardView, onDismiss: updateCards) {
                        NavigationStack {
                            SetupCardView(
                                viewModel: SetupCardViewModel(mode: .create),
                                showSetupCardView: $showSetupCardView)
                        }
                    }
                if !viewModel.isLoading, viewModel.showInfoView {
                    InfoView(showConfetti: $viewModel.showConfetti) {
                       updateCards()
                    }
                }
            }
        }
    }
    
    func updateCards() {
        Task {
            await viewModel.updateCards()
        }
    }
}
