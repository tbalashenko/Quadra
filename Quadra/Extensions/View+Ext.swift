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
        radius: CGFloat = 3,
        offset: CGFloat = 3
    ) -> some View {
        return self
            .shadow(
                color: .highlight, radius: radius, x: -offset, y: -offset)
            .shadow(
                color: .shadow, radius: radius, x: offset, y: offset)
    }

    func southEastShadow(
        radius: CGFloat = 3,
        offset: CGFloat = 3
    ) -> some View {
        return self
            .shadow(color: .shadow, radius: radius, x: -offset, y: -offset)
            .shadow(color: .highlight, radius: radius, x: offset, y: offset)
    }
}
