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
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
        if condition {
            content(self)
        } else {
            self
        }
    }
    
    func frame(size: CGSize, alignment: Alignment = .center) -> some View {
        self.frame(width: size.width, height: size.height,  alignment: alignment)
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}

extension View {
    public func popup<PopupContent: View>(
        isPresented: Binding<Bool>,
        view: @escaping () -> PopupContent
    ) -> some View {
        self.modifier(
            Popup(
                isPresented: isPresented,
                view: view)
        )
    }
}
