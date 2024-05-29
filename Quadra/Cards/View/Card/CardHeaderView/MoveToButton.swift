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
                            item: TagCloudItem(
                                isSelected: true,
                                id: UUID(),
                                title: model.card.getNewStatus.title,
                                color: model.card.getNewStatus.color,
                                action: { viewModel.removeCard(model: model, changeStatus: true) }
                            ),
                            withShadow: false,
                            isSelectable: false
                        )
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
