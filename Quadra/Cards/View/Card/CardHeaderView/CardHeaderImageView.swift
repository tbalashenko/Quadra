//
//  CardHeaderImageView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 23/05/2024.
//

import SwiftUI

struct CardHeaderImageView: View {
    let image: Image
    @State private var showFullImage: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            Button(action: {
                showFullImage.toggle()
            }) {
                ZStack {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.width * SettingsManager.shared.aspectRatio.ratio)
                        .clipped()
                        .northWestShadow()
                    
                    
                }
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.width * SettingsManager.shared.aspectRatio.ratio)
            .fullScreenCover(isPresented: $showFullImage) {
                FullImageView(image: image)
            }
        }
    }
}

//#Preview {
//    CardHeaderImageView()
//}
