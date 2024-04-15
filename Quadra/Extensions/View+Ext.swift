//
//  View+Ext.swift
//  SourdoughReminder
//
//  Created by Tatyana Balashenko on 02/10/2023.
//

import Foundation
import SwiftUI

extension View {
    func northWestShadow(
        radius: CGFloat = 4,
        offset: CGFloat = 3
    ) -> some View {
        return self
            .shadow(
                color: .highlight, radius: radius, x: -offset, y: -offset)
            .shadow(
                color: .shadow, radius: radius, x: offset, y: offset)
    }

    func southEastShadow(
        radius: CGFloat = 4,
        offset: CGFloat = 3
    ) -> some View {
        return self
            .shadow(color: .shadow, radius: radius, x: -offset, y: -offset)
            .shadow(color: .highlight, radius: radius, x: offset, y: offset)
    }
}

#Preview {
    ZStack(alignment: .center) {
        Rectangle()
            .fill(Color.element)
            .frame(width: 300, height: 300)
        Circle()
            .fill(Color.element)
            .frame(width: 200, height: 200)
            .northWestShadow()
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func styleFormSection() -> some View {
        self
            .backgroundStyle(Color.element)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.element)
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
}
