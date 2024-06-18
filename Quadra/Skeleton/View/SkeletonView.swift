//
//  SkeletonView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 04/04/2024.
//

import SwiftUI


struct SkeletonView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var gradientColors: [Color] {
        switch colorScheme {
            case .dark:
                return [Color(hex: "#D1D1D1"),
                        Color(hex: "#B3B3B2"),
                        Color(hex: "#D1D1D1")]
            case .light:
                return[Color(hex: "#E1E1E0"),
                       Color(hex: "#D1D1D1"),
                       Color(hex: "#E1E1E0")]
            @unknown default:
                return [Color(hex: "#D1D1D1"),
                        Color(hex: "#B3B3B2"),
                        Color(hex: "#D1D1D1")]
        }
    }
    
    @State var startPoint: UnitPoint = .init(x: -1.8, y: -1)
    @State var endPoint: UnitPoint = .init(x: 0, y: 0)
    
    var body: some View {
        LinearGradient (colors: gradientColors,
                        startPoint: startPoint,
                        endPoint: endPoint)
        .clipShape(RoundedRectangle(cornerRadius: SizeConstants.cornerRadius))
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: false)) {
                startPoint = .init(x: 1, y: 1)
                endPoint = .init(x: 2, y: 2)
            }
        }
    }
}

