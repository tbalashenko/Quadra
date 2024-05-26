//
//  StatEmptyView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 08/05/2024.
//

import SwiftUI

struct StatEmptyView: View {
    @EnvironmentObject var viewModel: StatViewModel
    
    var body: some View {
        ScrollView {
            Text(viewModel.getStatDataState().instructionFirstPart)
                .padding()
            HStack(spacing: 32) {
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.accent)
                DummyCardView(
                    viewModel: DummyCardsViewModel(),
                    model: DummyCardModel(item: MockData.cards[0]),
                    mode: .view)
                .frame(
                    width: SizeConstants.cardWith / 2,
                    height: SizeConstants.cardHeigh / 2)
                Spacer()
            }
            if let text = viewModel.getStatDataState().instructionSecondPart {
                Text(text)
                    .padding()
                DummyCardStackView()
                    .frame(
                        width: SizeConstants.cardWith / 2,
                        height: SizeConstants.cardHeigh / 2)
            }
        }
        .background(.element)
        .navigationTitle("Statistics")
    }
}

#Preview {
    StatEmptyView()
        .environmentObject(StatViewModel())
}
