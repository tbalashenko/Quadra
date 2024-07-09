//
//  MoveToButton.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 23/05/2024.
//

import SwiftUI

struct MoveToButton: View {
    var title: String
    var color: Color
    var action: (() -> Void)?
    
    var body: some View {
        AlignableTransparentButton(alignment: .topLeading) {
            HStack {
                Text("→").bold()
                TagView(text: title, backgroundColor: color)
            }
        } action: { action?() }
    }
}

 #Preview {
     MoveToButton(title: "input", color: Color.catawba)
 }
