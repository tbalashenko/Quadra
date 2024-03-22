//
//  ListView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])  var items: FetchedResults<Item>
    
    var body: some View {
        GeometryReader() { geometry in
            NavigationView {
                List(items) { item in
                    ListRow(item: item)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.element)
                        .background(
                            NavigationLink("", destination: CardView(item: item, geometry: geometry))
                                .opacity(0)
                        )
                }
                .listStyle(.plain)
                .listRowInsets(.none)
                .background(Color.element)
                .toolbar {
                    ToolbarItem {
                        Button {
                            filter()
                        } label: {
                            Label("Add Item", systemImage: "line.3.horizontal.decrease.circle.fill")
                        }
                    }
                }
            }
        }
    }
    
    
    func filter() {
        
    }
}

//#Preview {
//    var iitems = [" no NSValueTransformer with class name 'StatusTransformer' was found for attribute 'status' on entity 'Item'"]
//
//    return ListView(iitems: iitems)
//}


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
        //.padding()
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
