//
//  ListRowView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 27/03/2024.
//

import SwiftUI

struct ListRowView: View {
    @ObservedObject var card: Card
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text(AttributedString(card.phraseToRemember))
                .padding()
            Spacer()
            if let data = card.image,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 88, height: 88)
                    .background(Color.element)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .background(Color.element
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .northWestShadow()
        )
    }
}

//#Preview {
//    VStack {
//        ListRow(item: Item.sampleData.first!)
//        ListRow(item: Item.sampleData.last!)
//    }
//}

struct ContentLengthPreference: PreferenceKey {
   static var defaultValue: CGFloat { 0 }
   
   static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
      value = nextValue()
   }
}
