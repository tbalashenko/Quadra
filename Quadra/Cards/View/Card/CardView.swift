//
//  CardView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 30/05/2024.
//

import SwiftUI

struct CardView: View {
    @State var id = UUID()
    @ObservedObject var model: CardModel
    @State private var showSetupCardView = false
    var action: (() -> ())?
    
    var body: some View {
        ZStack {
            Color.element.ignoresSafeArea()
            ScrollView(.vertical) {
                CardHeaderView(model: model) { action?() }
                    .frame(
                        width: SizeConstants.cardWith,
                        height: SizeConstants.cardWith * SettingsManager.shared.aspectRatio.ratio
                    )
                FlipablePhraseView(viewModel: PhraseViewModel(cardModel: model))
                if model.showAdditionalInfo {
                    AdditionalnfoView(viewModel: AdditionalnfoViewModel(model: model))
                }
            }
            .frame(
                width: SizeConstants.cardWith,
                height: SizeConstants.cardHeigh
            )
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
            .sheet(
                isPresented: $showSetupCardView,
                onDismiss: { id = UUID() }
            ) {
                NavigationStack {
                    SetupCardView(
                        viewModel: SetupCardViewModel(mode: .edit(model: model)),
                        showSetupCardView: $showSetupCardView)
                }
            }
            .id(id)
        }
    }
}
//
//#Preview {
//    CardView()
//}
