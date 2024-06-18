//
//  SkeletonCardView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 05/04/2024.
//

import SwiftUI

struct SkeletonCardView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var imageColor: Color {
        colorScheme == .light ? Color.lightGray : Color.spanishGray
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                imageColor
                VStack {
                    HStack {
                        SkeletonView()
                            .frame(width: 150, height: 38)
                        Spacer()
                        SkeletonView()
                            .frame(width: 38, height: 38)
                    }
                    .padding(4)
                    Spacer()
                }
            }
            .frame(size: SizeConstants.imageSize)
            HStack(spacing: 12) {
                SkeletonView()
                    .frame(width: 22, height: 22)
                VStack(alignment: .leading) {
                    SkeletonView()
                        .frame(height: 22)
                    SkeletonView()
                        .frame(height: 22)
                    SkeletonView()
                        .frame(width: 100, height: 22)
                }
            }
            .padding()
            Spacer()
        }
        .background(Color.element)
        .clipShape(RoundedRectangle(cornerRadius: SizeConstants.cornerRadius))
        .southEastShadow()
        .frame(size: SizeConstants.cardSize)
    }
}

#Preview {
    GeometryReader { geometry in
        SkeletonCardView()
    }
}

