//
//  MoveToButton.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 23/05/2024.
//

import SwiftUI

struct MoveToButton: View {
    @ObservedObject var model: CardModel
    var action: (() -> ())?
    
    var body: some View {
        AlignableTransparentButton(alignment: .topLeading) {
            HStack {
                Text("→").bold()
                TagView(
                    item: TagCloudItem(
                        isSelected: true,
                        id: UUID(),
                        title: model.card.getNewStatus.title,
                        color: model.card.getNewStatus.color
                    )
                )
            }
        } action: { action?() }
    }
}

//#Preview {
//    MoveToButton()
//}
