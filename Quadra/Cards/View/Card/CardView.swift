//
//  CardView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 30/05/2024.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var model: CardModel
    @State private var showSetupCardView = false
    var action: (() -> Void)?
    
    var body: some View {
        ZStack {
            Color.element.ignoresSafeArea()
            VStack {
                CardHeaderView() { action?() }
                    .environmentObject(model)
                    .frame(size: SizeConstants.imageSize)
                    .padding(.bottom)
                
                FlipablePhraseView(model: model)
                
                if model.showAdditionalInfo {
                    AdditionalnfoView(model: model)
                }
                
                Spacer()
            }
            .frame(size: SizeConstants.cardSize)
            .background(.element)
            .clipShape(RoundedRectangle(cornerRadius: SizeConstants.cornerRadius))
            .southEastShadow()
            .toolbar {
                if model.canBeChanged {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showSetupCardView = true
                        } label: {
                            Image(systemName: "pencil")
                        }
                    }
                }
            }
            .sheet(isPresented: $showSetupCardView) {
                NavigationStack {
                    SetupCardView(
                        viewModel: SetupCardViewModel(mode: .edit, cardModel: model),
                        showSetupCardView: $showSetupCardView
                    )
                }
            }
        }
    }
}

 #Preview {
     @ObservedObject var cardModel = CardModel(card: MockData.cards.first!, mode: .view)
     
     CardView() { cardModel.backToInput() }
         .environmentObject(cardModel)
 }
