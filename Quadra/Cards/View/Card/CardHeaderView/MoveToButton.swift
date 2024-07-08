//
//  MoveToButton.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 23/05/2024.
//

import SwiftUI

struct MoveToButton: View {
    var title: String
    var color: Color
    var action: (() -> Void)?

    var body: some View {
        AlignableTransparentButton(alignment: .topLeading) {
            HStack {
                Text("→").bold()
                TagView(
                    item: TagCloudItem(
                        isSelected: true,
                        id: UUID(),
                        title: title,
                        color: color.toHex()
                    )
                )
            }
        } action: { action?() }
    }
}

// #Preview {
//    MoveToButton()
// }
