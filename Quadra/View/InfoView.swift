//
//  InfoView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 31/03/2024.
//

import SwiftUI

struct InfoView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
    @Binding var needUpdateView: Bool

    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    Spacer()

                    Button {
                        //
                    } label: {
                        Label("How to use the app", systemImage: "info.circle")
                    }
                    .buttonStyle(NeuButtonStyle(width: geometry.size.width / 2, height: 40))

                    Spacer()
                        .frame(height: 16)

                    Text(getHint())

                    if !items.filter({ $0.isReadyToRepeat }).isEmpty {
                        Button {
                            needUpdateView = true
                        } label: {
                            Label("Start again", systemImage: "repeat.circle")
                        }
                        .buttonStyle(NeuButtonStyle(width: geometry.size.width / 2, height: 40))
                    }
                    Spacer()
                }
                Spacer()
            }
            .onAppear {
                items.forEach { $0.setReadyToRepeat() }
                try? viewContext.save()
            }
        }
    }
    
    func getHint() -> String {
        let readyToRepeatItems = items.filter { $0.isReadyToRepeat }
        
        if items.isEmpty {
            return "Add your first card"
        } else if readyToRepeatItems.isEmpty {
            return "That's it for today, but you can add new cards"
        }
        
        return ""
    }
}

#Preview {
    InfoView(needUpdateView: .constant(true))
}
