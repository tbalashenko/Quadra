//
//  DummyCardStackView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 08/05/2024.
//

import SwiftUI

struct DummyCardStackView: View {
    @StateObject var viewModel = DummyCardsViewModel()

    var body: some View {
        ZStack(alignment: .center) {
            ForEach(viewModel.cardModels) { model in
                DummyCardView(
                    viewModel: viewModel,
                    model: model
                )
            }
            if viewModel.cardModels.isEmpty {
                Button {
                    viewModel.updateCardModels()
                } label: {
                    Image(systemName: "repeat.circle")
                        .smallButtonImage()
                }
                .buttonStyle(NeuButtonStyle())
            }
        }
    }
}

#Preview {
    DummyCardStackView()
        .frame(size: SizeConstants.cardSize)
}
