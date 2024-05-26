//
//  InfoButton.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 23/05/2024.
//

import SwiftUI

struct InfoButton: View {
    @ObservedObject var model: CardModel
    
    var body: some View {
        EdgeButtonView(image: Image(systemName: "info.circle.fill"), edge: .topRight) {
            model.showAdditionalInfo.toggle()
        }
    }
}

//#Preview {
//    InfoButton(model: CardModel(card: , mode: .view))
//}
