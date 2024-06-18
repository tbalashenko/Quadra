//
//  FullImageView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 09/04/2024.
//

import SwiftUI

struct FullImageView: View {
    @Environment(\.dismiss) var dismiss
    @GestureState private var dragOffset: CGSize = .zero
    let image: Image

    var body: some View {
        ZStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)
                .statusBar(hidden: true)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, dragOffset, _ in
                            dragOffset = value.translation
                        }
                        .onEnded { value in
                            if value.translation.height > 30 {
                                dismiss()
                            }
                        }
                )
                .gesture(
                    TapGesture().onEnded { _ in
                        dismiss()
                    }
                )
        }
    }
}

#Preview {
    FullImageView(image: Image("test"))
}
