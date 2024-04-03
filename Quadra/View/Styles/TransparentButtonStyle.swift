//
//  TransparentButtonStyle.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/03/2024.
//

import SwiftUI

struct TransparentButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.black)
            .padding(8)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.4))
            }
    }
}

extension ButtonStyle where Self == TransparentButtonStyle {
    static var transparentButtonStyle: TransparentButtonStyle { .init() }
}
