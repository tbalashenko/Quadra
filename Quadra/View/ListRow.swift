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
        HStack(alignment: .top, spacing: 8) {
            formatedText(for: item)
                .padding()
            Spacer()
            if let data = item.image,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
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
    
    func formatedText(for item: Item) -> Text {
        guard let firstLetter = item.phraseToRemember.first else {
            return Text(item.phraseToRemember)
        }
        
        let restOfPhrase = String(item.phraseToRemember.dropFirst())
        
        return Text(String(firstLetter))
            .bold()
            .foregroundColor(Color(hex: item.status.color))
            + Text(restOfPhrase)
    }
}

#Preview {
    VStack {
        ListRow(item: Item.sampleData.first!)
        ListRow(item: Item.sampleData.last!)
    }
}
