//
//  InfoView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 31/03/2024.
//

import SwiftUI

struct InfoView: View {
    @EnvironmentObject var dataManager: CardManager
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

                    Text(dataManager.getHint())

                    if dataManager.containsCardsToRepeat() {
                        Button {
                            dataManager.setReadyToRepeat()
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
        }
    }
}

#Preview {
    InfoView(needUpdateView: .constant(true))
}
