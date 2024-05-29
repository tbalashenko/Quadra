//
//  PhotoPickerView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 20/03/2024.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @State var photosPickerItem: PhotosPickerItem?
    @Binding var image: Image?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                if let image = image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                PhotosPicker(
                    selection: $photosPickerItem,
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
                    EdgeButtonView(
                        image: Image(systemName: "trash"),
                        edge: .topRight) {
                            self.photosPickerItem = nil
                        }
                }
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height)
            .onChange(of: photosPickerItem) {
                setImage()
            }
        }
    }
    
    func setImage() {
        Task {
            guard
                let data = try? await photosPickerItem?.loadTransferable(type: Data.self),
                let uiImage = UIImage(data: data)
            else { image = nil; return }
            
            image = Image(uiImage: uiImage)
        }
    }
}

#Preview {
    PhotoPickerView(image: .constant(nil))
}
