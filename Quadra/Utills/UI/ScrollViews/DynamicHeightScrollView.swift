//
//  DynamicHeightScrollView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 26/06/2024.
//

import SwiftUI

struct DynamicHeightScrollView<Content: View>: View {
    @State private var contentHeight: CGFloat = .zero
    let content: Content
    let maxHeight: CGFloat
    
    init(maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.maxHeight = maxHeight
    }
    
    var body: some View {
        ScrollView {
            VStack {
                content
                    .background(GeometryReader { geometry in
                        Color.clear
                            .preference(key: ViewHeightKey.self, value: geometry.size.height)
                    })
            }
            .onPreferenceChange(ViewHeightKey.self) { newHeight in
                self.contentHeight = newHeight
            }
        }
        .scrollIndicators(.hidden)
        .frame(height: min(contentHeight, maxHeight))
    }
}

struct ViewHeightKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
