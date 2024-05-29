//
//  PlainGroupBoxStyle.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 25/04/2024.
//

import SwiftUI

struct PlainGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
                .bold()
            configuration.content
        }
    }
}
