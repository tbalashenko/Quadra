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
        if isShown {
            GeometryReader { geometry in
                SpriteView(scene: ParticleScene(size: geometry.size),
                           options: [.allowsTransparency])
                .background(.clear)
                .transition(.opacity)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeInS) {
                        withAnimation(.linear(duration: 0.5)) {
                            isShown.toggle()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ConfettiView(isShown: .constant(true), timeInS: 2)
}
