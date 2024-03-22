//
//  PhotoPickerView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 20/03/2024.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    var width: CGFloat
    var heigh: CGFloat
    @Binding var photosPickerItem: PhotosPickerItem?
    @Binding var image: Image?
    var action: (()->())?
    
    var body: some View {
        ZStack(alignment: .center) {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width,
                           height: heigh)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .northWestShadow()
            }
            PhotosPicker(selection: $photosPickerItem,
                         matching: .images) {
                Label("Select Photo", systemImage: "photo")
                    .foregroundStyle(.black)
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white.opacity(0.6))
                    }
            }
            if photosPickerItem != nil {
                EdgeButtonView(action: {
                    photosPickerItem = nil
                }, image: Image(systemName: "trash"))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .frame(width: width,
                       height: heigh)
                .foregroundStyle(.element)
                .northWestShadow()
        )
        .frame(width: width,
               height: heigh)
        .onChange(of: photosPickerItem) {
            action?()
        }
    }
}


#Preview {
    PhotoPickerView(width: 300,
                    heigh: 300,
                    photosPickerItem: .constant(nil),
                    image: .constant(nil))
    .padding()
}
