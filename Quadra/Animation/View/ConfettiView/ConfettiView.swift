//
//  ConfettiView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 10/04/2024.
//

import SwiftUI
import SpriteKit

struct ConfettiView: View {
    @Binding var isPresented: Bool
    private var currentOpacity: CGFloat { isPresented ? 1 : 0 }

    var body: some View {
        GeometryReader { geometry in
            SpriteView(
                scene: ParticleScene(size: geometry.size),
                options: [.allowsTransparency]
            )
            .simultaneousGesture(
                TapGesture().onEnded {
                    isPresented = false
                }
            )
            .ignoresSafeArea()
            .background(Color.clear)
            .opacity(currentOpacity)
            .animation(.easeInOut, value: currentOpacity)
        }
    }
}

#Preview {
    ConfettiView(isPresented: .constant(true))
}
