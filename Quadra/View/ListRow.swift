//
//  ListRow.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 27/03/2024.
//

import SwiftUI

struct ListRow: View {
    var item: Item
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(item.phraseToRemember)
                        .padding(8)
                    Spacer()
                }
                HStack {
                    Spacer()
                    TagView(text: item.status.title,
                            backgroundColor: Color(hex: item.status.color))
                    .padding(.vertical, 4)
                }
            }
            Spacer()
            if let data = item.image,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 88, height: 88)
                    .background(Color.element)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .northWestShadow()
            }
        }
        .background(Color.element
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .northWestShadow()
        )
    }
}


#Preview {
    VStack {
        ListRow(item: Item.sampleData.first!)
        ListRow(item: Item.sampleData.last!)
    }
}
