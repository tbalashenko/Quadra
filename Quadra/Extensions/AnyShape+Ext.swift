//
//  AnyShape+Ex.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 18/03/2024.
//

import SwiftUI

extension Shape {
    func northWestInnerShadow(radius: CGFloat = 3, offset: CGFloat = 3) -> some View {
        return self.fill(
                .shadow(.inner(color: .highlight, radius: radius, x: -offset, y: -offset))
                .shadow(.inner(color: .shadow, radius: radius, x: offset, y: offset))
        )
    }
    
    func southEastInnerShadow(radius: CGFloat = 3, offset: CGFloat = 3) -> some View {
        return self.fill(
                .shadow(.inner(color: .highlight, radius: radius, x: offset, y: offset))
                .shadow(.inner(color: .shadow, radius: radius, x: -offset, y: -offset))
        )
    }

}
