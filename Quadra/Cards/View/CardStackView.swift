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
                    CardView(
                        viewModel: viewModel,
                        model: model
                    )
                }
            }
        }
        .frame(
            width: SizeConstants.cardWith,
            height: SizeConstants.cardHeigh)
        .onAppear {
            Task {
                await viewModel.updateCards()
            }
        }
    }
}

#Preview {
    CardStackView(viewModel: CardsViewModel())
        .frame(
            width: SizeConstants.cardWith,
            height: SizeConstants.cardHeigh
        )
}
