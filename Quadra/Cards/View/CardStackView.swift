//
//  CardStackView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 21/05/2024.
//

import SwiftUI

struct CardStackView: View {
    @StateObject var viewModel: CardsViewModel

    var body: some View {
        ZStack(alignment: .center) {
            if viewModel.isLoading {
                SkeletonCardView()
            } else {
                ForEach(viewModel.visibleCardModels) { model in
                    SwipeableCardView(
                        viewModel: viewModel,
                        model: model
                    )
                    .frame(size: SizeConstants.cardSize)
                }
            }
        }
        .onDisappear {
            viewModel.showConfetti = false
        }
    }
}

#Preview {
    CardStackView(viewModel: CardsViewModel())
        .frame(size: SizeConstants.cardSize)
}
