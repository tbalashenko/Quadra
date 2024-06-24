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
    @Binding var croppedImage: Image?
    @State var showEditingView: Bool = false

    var body: some View {
        ZStack(alignment: .center) {
            croppedImage?
                .resizable()
                .scaledToFill()
                .frame(size: SizeConstants.imageSize)
                .clipShape(RoundedRectangle(cornerRadius: SizeConstants.cornerRadius))
            
            PhotosPicker(
                selection: $photosPickerItem,
                matching: .images
            ) {
                Label(TextConstants.selectPhoto, systemImage: "photo")
                    .foregroundStyle(.black)
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white.opacity(0.6))
                    }
            }
            
            if croppedImage != nil {
                AlignableTransparentButton(
                    alignment: .topTrailing
                ) {
                    Image(systemName: "trash")
                        .smallButtonImage()
                } action: {
                    clearImages()
                }
                
                AlignableTransparentButton(
                    alignment: .topLeading
                ) {
                    Image(systemName: "crop")
                        .smallButtonImage()
                        
                } action: {
                    showEditingView.toggle()
                }
            }
        }
        .frame(size: SizeConstants.imageSize)
        .onChange(of: photosPickerItem) {
            setImage()
        }
        .fullScreenCover(isPresented: $showEditingView) {
            if let image {
                CropView(image: image) { croppedImage, _ in
                    if let croppedImage {
                        Task {
                            await MainActor.run {
                                self.croppedImage = croppedImage
                            }
                        }
                    }
                }
            }
        }
    }

    func setImage() {
        Task {
            guard
                let data = try? await photosPickerItem?.loadTransferable(type: Data.self),
                let uiImage = UIImage(data: data)
            else {
                clearImages()
                return
            }
            
            await MainActor.run {
                image = Image(uiImage: uiImage)
                croppedImage = Image(uiImage: uiImage)
            }
        }
    }

    func clearImages() {
        Task {
            await MainActor.run {
                self.croppedImage = nil
                self.image = nil
            }
        }
    }
}

#Preview {
    PhotoPickerView(image: .constant(nil), croppedImage: .constant(nil))
}
