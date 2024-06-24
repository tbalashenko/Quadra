//
//  InfoView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 31/03/2024.
//

import SwiftUI

final class InfoViewModel: ObservableObject {
    @Published var isReadyToRepeat = false

    init() {
        isReadyToRepeat = !CardService.shared.cards
            .filter { $0.isReadyToRepeat }
            .isEmpty
    }

    func getHint() -> String {
        let cards = CardService.shared.cards
        let readyToRepeatCards = cards.filter { $0.isReadyToRepeat }

        if cards.isEmpty {
            return TextConstants.addFirstCards
        } else if readyToRepeatCards.isEmpty {
            return TextConstants.thatsItForToday
        }

        return ""
    }

}

struct InfoView: View {
    @StateObject var viewModel = InfoViewModel()
    var onAction: (() -> Void)?
    
    var body: some View {
        VStack {
            Button {
                
            } label: {
                Label(TextConstants.howToUseApp, systemImage: "info.circle")
            }
            .buttonStyle(NeuButtonStyle(size: SizeConstants.plainButtonSize))
            Spacer()
                .frame(height: 16)
            
            Text(viewModel.getHint())
            
            if viewModel.isReadyToRepeat {
                Button {
                    onAction?()
                } label: {
                    Label(TextConstants.restart, systemImage: "repeat.circle")
                }
                .buttonStyle(NeuButtonStyle(size: SizeConstants.plainButtonSize))
            }
        }
    }
}

#Preview {
    InfoView()
}
