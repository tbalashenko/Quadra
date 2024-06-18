//
//  Popup.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/06/2024.
//

import SwiftUI

public struct Popup<PopupContent>: ViewModifier where PopupContent: View {
    @Binding var isPresented: Bool
    @State private var presenterContentRect: CGRect = .zero
    @State private var sheetContentRect: CGRect = .zero
    
    var view: () -> PopupContent
    
    private var currentOpacity: CGFloat {
        return isPresented ? 1 : 0
    }
    
    init(isPresented: Binding<Bool>,
         view: @escaping () -> PopupContent) {
        self._isPresented = isPresented
        self.view = view
    }

    public func body(content: Content) -> some View {
        content
            .overlay {
                self.view()
                    .simultaneousGesture(
                        TapGesture().onEnded {
                            isPresented = false
                        }
                    )
                    .ignoresSafeArea()
                    .opacity(currentOpacity)
                    .animation(Animation.easeOut(duration: 0.3), value: currentOpacity)
            }
    }
}
