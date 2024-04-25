//
//  NeuButtonStyle.swift
//  SourdoughReminder
//
//  Created by Tatyana Balashenko on 02/10/2023.
//

import SwiftUI


struct NeuButtonStyle: ButtonStyle {
    enum NeuButtonStyleForm {
        case capsule
        case roundedRectangle
    }
    
    var width: CGFloat = 22
    var height: CGFloat = 22
    var color = Color.element
    
    var form: NeuButtonStyleForm = .capsule

    func makeBody(configuration: Self.Configuration)
    -> some View {
        let shape = form == .capsule ? AnyShape(Capsule()) : AnyShape(RoundedRectangle(cornerRadius: 8))
        
        configuration.label
            .frame(width: width, height: height)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .background(
                shape
                    .fill(color)
                    .northWestShadow(
                        radius: configuration.isPressed ? 1 : 2,
                        offset: configuration.isPressed ? 1 : 2)
                    .scaleEffect(configuration.isPressed ? 0.98: 1)
            )
    }
}
