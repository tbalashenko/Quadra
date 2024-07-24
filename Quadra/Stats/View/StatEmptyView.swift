//
//  StatEmptyView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 08/05/2024.
//

import SwiftUI

struct StatEmptyView: View {
    @ObservedObject var statDataService = StatDataService.shared
    
    var body: some View {
        ScrollView {
            if statDataService.statData.isEmpty {
                Text(TextConstants.addFirstCards)
                    .padding()
                HStack(spacing: 32) {
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.accent)
                    DummyCardView(
                        viewModel: DummyCardsViewModel(),
                        model: DummyCardModel(item: MockData.mockedCards[0]),
                        mode: .view)
                    .frame(size: SizeConstants.dummyCardSize)
                    Spacer()
                }
            }
            Text(TextConstants.continueAddAndRepHelp)
                .padding()
            HStack {
                Spacer()
                DummyCardStackView()
                    .frame(size: SizeConstants.dummyCardSize)
                Spacer()
            }
        }
        .background(.element)
        .navigationTitle(TextConstants.statistics)
    }
}

#Preview {
    StatEmptyView()
}
