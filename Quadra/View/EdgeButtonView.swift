//
//  EdgeButtonView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 20/03/2024.
//

import SwiftUI

struct EdgeButtonView: View {
    var action: (()->())?
    var image: Image
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    action?()
                } label: {
                    image
                        .frame(width: 22, height: 22)
                }
                .buttonStyle(.transparentButtonStyle)
                .padding()
            }
            Spacer()
        }
    }
}

#Preview {
    ZStack {
        RoundedRectangle(cornerRadius: 8)
        EdgeButtonView(action: {
            print("+")
        }, image: Image(systemName: "plus"))
    }
    .frame(width: 300, height: 300)
}
