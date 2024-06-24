//
//  CustomPopup.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 10/06/2024.
//

import SwiftUI

struct CustomPopup: View {
    var text: String
    @Binding var showPopup: Bool

    var body: some View {
        Text(text)
            .foregroundColor(.white)
            .padding(10)
            .transition(.opacity)
            .background(Color.black.opacity(0.6))
            .cornerRadius(SizeConstants.cornerRadius)
            .zIndex(1)
            .northWestShadow()
            .onChange(of: showPopup) { _, showPopup in
                if showPopup {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.showPopup = false
                    }
                }
            }

    }
}

#Preview {
    CustomPopup(text: "Copied!", showPopup: .constant(true))
}
