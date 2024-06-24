//
//  CardStackView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 21/05/2024.
//

import SwiftUI

struct CardStackView: View {
    @EnvironmentObject var viewModel: CardsViewModel
    
    var body: some View {
        ZStack(alignment: .center) {
            if !viewModel.isLoading {
                ForEach(viewModel.visibleCardModels, id: \.id) { model in
                    SwipeableCardView()
                        .environmentObject(viewModel)
                        .environmentObject(model)
                        .frame(size: SizeConstants.cardSize)
                }
            }
        }
    }
        
}

#Preview {
    CardStackView()
        .environmentObject(CardsViewModel())
        .frame(size: SizeConstants.cardSize)
}
