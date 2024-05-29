//
//  InfoView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 31/03/2024.
//

import SwiftUI

final class InfoViewModel: ObservableObject {
    @Published var isReadyToRepeat = false
    private let cardService = CardService.shared
    
    init() {
        isReadyToRepeat = !CardService.shared.cards
            .filter { $0.isReadyToRepeat }
            .isEmpty
    }
    
    func getHint() -> String {
        let cards = CardService.shared.cards
        let readyToRepeatCards = cards.filter { $0.isReadyToRepeat }
        
        if cards.isEmpty {
            return "Add your first card"
        } else if readyToRepeatCards.isEmpty {
            return "That's it for today, but you can add new cards"
        }
        
        return ""
    }
    
}

struct InfoView: View {
    @StateObject var viewModel = InfoViewModel()
    @Binding var showConfetti: Bool
    var onAction: (() -> Void)?

    var body: some View {
        ZStack {
            ConfettiView(isShown: $showConfetti, timeInS: 4)
            VStack {
                Button {
                    
                } label: {
                    Label("How to use the app", systemImage: "info.circle")
                }
                .buttonStyle(NeuButtonStyle(
                    width: SizeConstants.buttonWith,
                    height: SizeConstants.buttonHeigh))
                Spacer()
                    .frame(height: 16)
                
                Text(viewModel.getHint())
                
                if viewModel.isReadyToRepeat {
                    Button {
                        onAction?()
                    } label: {
                        Label("Start again", systemImage: "repeat.circle")
                    }
                    .buttonStyle(NeuButtonStyle(
                        width: SizeConstants.buttonWith,
                        height: SizeConstants.buttonHeigh))
                }
            }
            
        }
    }
    
}

#Preview {
    InfoView(showConfetti: .constant(true))
}
