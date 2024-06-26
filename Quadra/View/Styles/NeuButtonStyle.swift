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
    
    var color = Color.element
    var size: CGSize = SizeConstants.smallButtonImageSize
    var form: NeuButtonStyleForm = .capsule
    
    func makeBody(configuration: Self.Configuration) -> some View {
        let shape = form == .capsule ? AnyShape(Capsule()) : AnyShape(RoundedRectangle(cornerRadius: SizeConstants.cornerRadius))
        
        configuration.label
            .frame(size: size)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .background(
                shape
                    .fill(color)
                    .northWestShadow(
                        radius: configuration.isPressed ? 1 : 2,
                        offset: configuration.isPressed ? 1 : 2
                    )
                    .scaleEffect(configuration.isPressed ? 0.98: 1)
            )
    }
}
