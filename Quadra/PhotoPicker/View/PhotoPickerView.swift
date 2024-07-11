//
//  PhotoPickerView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 20/03/2024.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @ObservedObject var viewModel: SetupCardViewModel
    
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var showEditingView: Bool = false
    @State var isPhotoLibraryAvailable = false
    
    var body: some View {
        ZStack(alignment: .center) {
            croppedImageView()
            
            VStack {
                photoPicker()
                urlViewButton()
            }
            
            if viewModel.croppedImage != nil {
                trashButton()
                cropButton()
            }
        }
        .frame(size: SizeConstants.imageSize)
        .center()
        .onChange(of: photosPickerItem) { setImage() }
        .fullScreenCover(isPresented: $showEditingView) { cropView() }
    }
    
    @ViewBuilder
    private func croppedImageView() -> some View {
        viewModel.croppedImage?
            .resizable()
            .scaledToFill()
            .frame(size: SizeConstants.imageSize)
            .clipShape(RoundedRectangle(cornerRadius: SizeConstants.cornerRadius))
    }
    
    @ViewBuilder
    private func photoPicker() -> some View {
        let label = Label(TextConstants.selectPhoto, systemImage: "photo")
        
        Group {
            if isPhotoLibraryAvailable {
                PhotosPicker(
                    selection: $photosPickerItem,
                    matching: .images,
                    label: { label }
                )
            } else {
                Button(
                    action: { PhotoLibraryService.checkPhotoLibraryAccess { isPhotoLibraryAvailable = $0 }},
                    label : { label }
                )
            }
        }
        .buttonStyle(TransparentButtonStyle())
        .onAppear { PhotoLibraryService.checkPhotoLibraryAccess { isPhotoLibraryAvailable = $0 }}
    }
    
    @ViewBuilder
    private func urlViewButton() -> some View {
        if !viewModel.showImageUrlSection {
            Button {
                withAnimation {
                    viewModel.showImageUrlSection = true
                }
            } label: {
                Label(TextConstants.enterImageURL, systemImage: "link")
            }
            .buttonStyle(TransparentButtonStyle())
        }
    }
    
    @ViewBuilder
    private func trashButton() -> some View {
        AlignableTransparentButton(
            alignment: .topTrailing
        ) {
            Image(systemName: "trash")
                .smallButtonImage()
        } action: {
            clearImages()
        }
    }
    
    @ViewBuilder
    private func cropButton() -> some View {
        AlignableTransparentButton(
            alignment: .topLeading
        ) {
            Image(systemName: "crop")
                .smallButtonImage()
        } action: {
            showEditingView.toggle()
        }
    }
    
    @ViewBuilder
    private func cropView() -> some View {
        if let image = viewModel.image {
            CropView(image: image) { croppedImage, _ in
                if let croppedImage {
                    Task {
                        await MainActor.run {
                            viewModel.croppedImage = croppedImage
                        }
                    }
                }
            }
        }
    }
    
    private func setImage() {
        Task {
            guard
                let data = try? await photosPickerItem?.loadTransferable(type: Data.self),
                let uiImage = UIImage(data: data)
            else {
                clearImages()
                return
            }
            
            await MainActor.run {
                viewModel.image = Image(uiImage: uiImage)
                viewModel.croppedImage = Image(uiImage: uiImage)
            }
        }
    }
    
    private func clearImages() {
        Task {
            await MainActor.run {
                viewModel.croppedImage = nil
                viewModel.image = nil
            }
        }
    }
}

//#Preview {
//    PhotoPickerView(image: .constant(nil), croppedImage: .constant(nil))
//}
