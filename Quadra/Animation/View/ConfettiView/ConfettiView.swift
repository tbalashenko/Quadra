//
//  ConfettiView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 10/04/2024.
//

import SwiftUI
import SpriteKit

struct ConfettiView: View {
    @Binding var isShown: Bool
    var timeInS: Double

    var body: some View {
        GeometryReader { geometry in
            if isShown {
                SpriteView(
                    scene: ParticleScene(size: geometry.size),
                    options: [.allowsTransparency]
                )
                .ignoresSafeArea()
                .background(Color.clear)
                .transition(.opacity)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeInS) {
                        isShown = false
                    }
                }
                .onDisappear {
                    isShown = false
                }
            }
        }
    }
}

#Preview {
    ConfettiView(isShown: .constant(true), timeInS: 2)
}
