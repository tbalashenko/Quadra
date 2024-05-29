//
//  GroupBoxStyleModifier.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 27/05/2024.
//

import SwiftUI

struct GroupBoxStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .styleListSection()
            .groupBoxStyle(PlainGroupBoxStyle())
    }
}

extension View {
    func applyFormStyle() -> some View {
        self.modifier(GroupBoxStyleModifier())
    }
}
