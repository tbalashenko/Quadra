//
//  CopyButton.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/06/2024.
//

import SwiftUI

struct CopyButton: View {
    var text: String
    var action: (() -> Void)?

    var body: some View {
        Button {
            UIPasteboard.general.string = text
            action?()
        } label: {
            Image(systemName: "doc.on.doc")
                .smallButtonImage()
                .foregroundColor(Color.accentColor)
        }
        .frame(size: SizeConstants.smallButtonImageSize)
    }
}

// #Preview {
//    CopyPasteButton()
// }
