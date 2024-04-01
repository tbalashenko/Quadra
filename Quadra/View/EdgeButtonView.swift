//
//  EdgeButtonView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 20/03/2024.
//

import SwiftUI

enum Edge {
    case topRight
    case topLeft
    case bottomRight
    case bottomLeft
}

struct EdgeButtonView: View {
    var image: Image
    var edge: Edge
    var action: (() -> Void)?

    var body: some View {
        VStack {
            if edge == .bottomLeft || edge == .bottomRight { Spacer() }
            HStack {
                if edge == .topRight || edge == .bottomRight { Spacer() }

                Button {
                    action?()
                } label: {
                    image
                        .resizable()
                        .frame(width: 22, height: 22)
                }
                .buttonStyle(.transparentButtonStyle)
                .padding()

                if edge == .topLeft || edge == .bottomLeft { Spacer() }
            }
            if edge == .topLeft || edge == .topRight { Spacer() }
        }
    }
}

#Preview {
    ZStack {
        RoundedRectangle(cornerRadius: 8)
        EdgeButtonView(image: Image(systemName: "plus"),
                       edge: .bottomLeft) {
            print("+")
        }
    }
    .frame(width: 300, height: 300)
}
