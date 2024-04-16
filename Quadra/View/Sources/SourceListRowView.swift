//
//  SourceListRow.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 12/04/2024.
//

import SwiftUI

struct SourceListRowView: View {
    @ObservedObject var source: ItemSource
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var viewContext
    @State var isEditing = false
    @State var title = ""
    
    var body: some View {
        HStack(spacing: 24) {
            ColorPicker("", selection: Binding<Color>(
                get: { Color(hex: source.color) },
                set: {
                    source.color = $0.toHex()
                    try? viewContext.save()
                }
            ))
            .frame(width: 22, height: 22)
            .northWestShadow()
            
            if isEditing {
                HStack(spacing: 12) {
                    TextField("", text: $title)
                        .textFieldStyle(NeuTextFieldStyle(text: $title))
                    
                    Spacer()
                    
                    Button {
                        source.title = title
                        try? viewContext.save()
                        isEditing = false
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .foregroundStyle(title.isEmpty ? Color.Green.isabelline : Color.Green.darkSeaGreen)
                    }
                    .buttonStyle(NeuButtonStyle(width: 22, height: 22))
                    .disabled(title.isEmpty)
                    
                    Button {
                        title = source.title
                        isEditing = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .foregroundStyle(Color.puce)
                    }
                    .buttonStyle(NeuButtonStyle(width: 22, height: 22))
                }
            } else {
                getTitle(for: source)
                    .onTapGesture {
                        isEditing = true
                        title = source.title
                    }
                Spacer()
            }
            
        }
        .padding()
        .background(Color.element
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .northWestShadow()
        )
        .listRowBackground(Color.element)
        .listRowSeparator(.hidden)
    }
    
    private func getTitle(for source: ItemSource) -> Text {
        if let count = source.items?.count {
            switch count {
                case 0:
                    return Text("\(source.title) - no cards")
                case 1:
                    return Text("\(source.title) - \(count) card")
                default:
                    return Text("\(source.title) - \(count) cards")
            }
        } else {
            return Text(source.title)
        }
    }
}

//#Preview {
//    SourceListRowView()
//}
