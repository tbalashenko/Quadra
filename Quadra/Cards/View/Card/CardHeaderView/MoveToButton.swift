//
//  MoveToButton.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 23/05/2024.
//

import SwiftUI

struct MoveToButton: View {
    @ObservedObject var viewModel: CardsViewModel
    @ObservedObject var model: CardModel
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.removeCard(model: model, changeStatus: true)
                }) {
                    HStack {
                        Text("→").bold()
                        TagView(
                            text: model.card.getNewStatus.title,
                            backgroundColor: Color(hex: model.card.getNewStatus.color),
                            withShadow: false) {
                                viewModel.removeCard(model: model, changeStatus: true)
                            }
                    }
                }
                .padding(4)
                .buttonStyle(.transparentButtonStyle)
                Spacer()
            }
            Spacer()
        }
    }
}

//#Preview {
//    MoveToButton()
//}
