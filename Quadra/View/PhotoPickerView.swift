//
//  PhotoPickerView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 20/03/2024.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    var geometry: GeometryProxy
    @Binding var photosPickerItem: PhotosPickerItem?
    @Binding var image: Image?
    var action: (() -> Void)?

    var body: some View {
        ZStack {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width * 0.85,
                           height: geometry.size.width * 0.85)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
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
                EdgeButtonView(image: Image(systemName: "trash"),
                               edge: .topRight,
                               action: { photosPickerItem = nil })
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .frame(width: geometry.size.width * 0.85,
                       height: geometry.size.width * 0.85)
                .foregroundStyle(.element)
                .northWestShadow()
        )
        .frame(width: geometry.size.width * 0.85,
               height: geometry.size.width * 0.85)
        .onChange(of: photosPickerItem) {
            action?()
        }
        .padding(.vertical)
    }
}

#Preview {
    GeometryReader { geometry in
        PhotoPickerView(geometry: geometry,
                        photosPickerItem: .constant(nil),
                        image: .constant(nil))
    }
}
