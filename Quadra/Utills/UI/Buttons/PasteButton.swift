//
//  PasteButton.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 24/06/2024.
//

import SwiftUI

struct PasteButton: View {
    var action: ((String) -> Void)?

    var body: some View {
        Button {
            Task {
                await MainActor.run {
                    action?(UIPasteboard.general.string ?? "")
                }
            }
        } label: {
            Image(systemName: "doc.on.clipboard")
                .smallButtonImage()
                .foregroundColor(Color.accentColor)
        }
        .frame(size: SizeConstants.smallButtonImageSize)
    }
}

#Preview {
    PasteButton()
}
