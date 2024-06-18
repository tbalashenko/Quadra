//
//  CardHeaderImageView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 23/05/2024.
//

import SwiftUI

struct CardHeaderImageView: View {
    let image: Image
    let croppedImage: Image
    @State private var showFullImage: Bool = false

    var body: some View {
        Button(action: {
            showFullImage.toggle()
        }) {
            ZStack {
                croppedImage
                    .resizable()
                    .scaledToFill()
                    .frame(size: SizeConstants.imageSize)
                    .clipped()
                    .northWestShadow()

            }
        }
        .frame(size: SizeConstants.imageSize)
        .fullScreenCover(isPresented: $showFullImage) {
            FullImageView(image: image)
        }
        .drawingGroup()
    }
}

#Preview {
    CardHeaderImageView(image: Image("hello-world"), croppedImage: Image("hello-world"))
}
