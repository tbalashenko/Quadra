//
//  CropView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 13/06/2024.
//

import SwiftUI
import PhotosUI

struct CropView: View {
    var image: Image?
    var onCrop: (Image?, Bool) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1
    @State private var magnifyBy: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset = CGSize.zero
    @State private var rotationDegrees: Double = 0
    @GestureState private var isInteracting = false

    var body: some View {
        NavigationStack {
            ZStack {
                imageView()
                    .navigationTitle(TextConstants.cropImage)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button {
                                dismiss()
                            } label: {
                                Text(TextConstants.cancel)
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button {
                                let renderer = ImageRenderer(content: imageView(hideGrids: true))

                                if let uiImage = renderer.uiImage {
                                    onCrop(Image(uiImage: uiImage), true)
                                } else {
                                    onCrop(nil, false)
                                }
                                dismiss()

                            } label: {
                                Text(TextConstants.save)
                            }
                        }
                    }
                AlignableTransparentButton(alignment: .topLeading) {
                    Image(systemName: "rotate.left")
                        .smallButtonImage()
                } action: {
                    rotationDegrees -= 90
                    reset()
                }
                .padding()
                AlignableTransparentButton(alignment: .topTrailing) {
                    Image(systemName: "rotate.right")
                        .smallButtonImage()
                } action: {
                    rotationDegrees += 90
                    reset()
                }
                .padding()
            }
            .background {
                Color.element
                    .ignoresSafeArea()
            }
        }
    }

    @ViewBuilder
    private func imageView(hideGrids: Bool = false) -> some View {
        GeometryReader {
            let size = $0.size

            image?
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay {
                    GeometryReader { geometry in
                        let rect = geometry.frame(in: .named("CropView"))

                        Color.clear
                            .onChange(of: isInteracting) { _, newValue in
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    if rect.size.width < size.width || rect.size.height < size.height {
                                        reset()
                                        return
                                    }

                                    if rect.minX > 0  {
                                        offset.width = offset.width.rounded() - (rect.minX / scale).rounded()
                                        haptic(.medium)
                                    }
                                    
                                    if rect.maxX < size.width {
                                        offset.width = (rect.minX / scale).rounded() - offset.width.rounded()
                                        haptic(.medium)
                                    }
                                    
                                    if rect.minY > 0 {
                                        offset.height = offset.height.rounded() - (rect.minY / scale).rounded()
                                        haptic(.medium)
                                    }

                                    if rect.maxY < size.height {
                                        offset.height = (rect.minY / scale).rounded() - offset.height.rounded()
                                        haptic(.medium)
                                    }
                                }

                                if !newValue {
                                    lastStoredOffset = offset
                                }
                            }
                    }
                }
                .frame(size: size)
        }
        .rotationEffect(Angle(degrees: rotationDegrees))
        .offset(offset)
        .scaleEffect(scale * magnifyBy)
        .overlay {
            if !hideGrids {
                grids()
            }
        }
        .coordinateSpace(name: "CropView")
        .gesture(drag)
        .gesture(magnification)
        .frame(size: SizeConstants.imageSize)
    }

    @ViewBuilder
    private func grids() -> some View {
        ZStack {
            HStack {
                ForEach(1...2, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.accentColor.opacity(0.5))
                        .frame(width: 1)
                        .frame(maxWidth: .infinity)
                }
            }
            VStack {
                ForEach(1...2, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.accentColor.opacity(0.5))
                        .frame(height: 1)
                        .frame(maxHeight: .infinity)
                }
            }
        }
        .border(Color.accentColor, width: 2)
    }

    private func reset() {
        offset = .zero
        scale = 1
    }
}

extension CropView {
    private var magnification: some Gesture {
        MagnifyGesture()
            .updating($isInteracting) { _, state, _ in
                state = true
            }
            .onChanged { value in
                magnifyBy = value.magnification
            }
            .onEnded { value in
                scale *= value.magnification
                magnifyBy = 1
            }
    }

    private var drag: some Gesture {
        DragGesture()
            .updating($isInteracting) { _, state, _ in
                state = true
            }
            .onChanged { value in
                let translation = value.translation
                offset = CGSize(width: translation.width + lastStoredOffset.width, height: translation.height + lastStoredOffset.height)
            }
    }
}

#Preview {
    CropView(image: Image("test")) { _, _ in

    }
}
