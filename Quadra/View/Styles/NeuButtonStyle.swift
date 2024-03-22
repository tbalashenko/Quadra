//
//  NeuButtonStyle.swift
//  SourdoughReminder
//
//  Created by Tatyana Balashenko on 02/10/2023.
//

import SwiftUI

struct NeuButtonStyle: ButtonStyle {
    let width: CGFloat
    let height: CGFloat
    
    func makeBody(configuration: Self.Configuration)
    -> some View {
        configuration.label
            .frame(width: width, height: height)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .background(
                Capsule()
                    .fill(Color.element)
                    .northWestShadow(
                        radius: configuration.isPressed ? 1 : 2,
                        offset: configuration.isPressed ? 1 : 2)
                    .scaleEffect(configuration.isPressed ? 0.98: 1)
            )
    }
}

//extension ButtonStyle where Self == NeuButtonStyle {
//    static var neuButtonStyle: NeuButtonStyle { .init() }
//}
