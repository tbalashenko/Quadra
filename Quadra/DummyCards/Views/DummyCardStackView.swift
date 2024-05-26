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
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                ForEach(viewModel.cardModels) { model in
                    DummyCardView(
                        viewModel: viewModel,
                        model: model)
                }
                if viewModel.cardModels.isEmpty {
                    Button {
                        viewModel.updateCardModels()
                    } label: {
                        Image(systemName: "repeat.circle")
                            .resizable()
                            .frame(width: 22, height: 22)
                    }
                    .buttonStyle(NeuButtonStyle())
                }
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height)
        }
    }
}

#Preview {
    DummyCardStackView()
        .frame(
            width: SizeConstants.cardWith,
            height: SizeConstants.cardHeigh
        )
}
