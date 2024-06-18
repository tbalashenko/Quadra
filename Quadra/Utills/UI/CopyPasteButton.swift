//
//  CopyPasteButton.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/06/2024.
//

import SwiftUI

struct CopyPasteButton: View {
    enum CopyPasteMode {
        case copy(String)
        case paste((String) -> Void)

        var imageName: String {
            switch self {
                case .copy:
                    return "doc.on.doc.fill"
                case .paste:
                    return "doc.on.clipboard.fill"
            }
        }
    }

    let mode: CopyPasteMode
    @Binding var showPopup: Bool

    var body: some View {
        Button(action: performAction) {
            Image(systemName: mode.imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.accentColor)
                .frame(width: 22, height: 22)
        }
    }

    private func performAction() {
        switch mode {
            case .copy(let text):
                UIPasteboard.general.string = text
                showPopupWithDelay()
            case .paste(let pasteAction):
                if let pasteboardString = UIPasteboard.general.string {
                    pasteAction(pasteboardString)
                    showPopupWithDelay()
                }
        }
    }

    private func showPopupWithDelay() {
        withAnimation {
            showPopup = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showPopup = false
        }
    }
}

// #Preview {
//    CopyPasteButton()
// }
