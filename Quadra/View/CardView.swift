//
//  CardView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/03/2024.
//

import SwiftUI

struct CardView: View {
    var item: Item
    
    let id = UUID()
    var geometry: GeometryProxy
    var gridLayout: [GridItem] = [ GridItem(.adaptive(minimum: 100, maximum: 300)), GridItem(.adaptive(minimum: 100, maximum: 300)), GridItem(.adaptive(minimum: 100, maximum: 300)) ]
    @State var showTranslation = false
    #warning("change it")
    @State var showAdditionalInfo = true
    @State private var totalHeight = CGFloat.infinity
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    if let data = item.image,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width - 32,
                                   height: geometry.size.height * 1/2)
                            .clipped()
                            .northWestShadow()
                    }
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                showAdditionalInfo.toggle()
                            }, label: {
                                Image(systemName: "info.circle.fill")
                                    .frame(width: 22, height: 22)
                            })
                            .buttonStyle(.transparentButtonStyle)
                            .padding()
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            TagView(text: item.status.title,
                                    backgroundColor: Color(hex: item.status.color))
                                .padding()
                        }
                    }
                }
                .frame(width: geometry.size.width - 32,
                       height: geometry.size.height * 1/2)
                
                Text(!showTranslation ? (item.phraseToRemember ) : item.translation ?? "refewf")
                    .bold()
                    .padding(.horizontal)
                    .onTapGesture {
                        showTranslation.toggle()
                    }
                
                if !showTranslation, let transcripton = item.transcription {
                    Text("[" + transcripton + "]")
                }
                
                if showAdditionalInfo {
                    VStack {
                        if let sources = item.sources?.allObjects as? [Source] {
                            TagCloudView(items: sources, geometry: geometry, totalHeight: $totalHeight)
                        }
                        if let additionTime = item.additionTime {
                            Text("Added: \(additionTime.formatted(date: .abbreviated, time: .shortened))")
                        }
                        Text("Number of repetitions: 0")
                    }
                }
                Spacer()
            }
            .background(.element)
            .cornerRadius(8)
            .northWestShadow()
            .padding()
        }
    }
}



extension CardView: Identifiable { }

#Preview {
    GeometryReader { geometry in
        CardView(item: Item(image: UIImage(named: "test")?.pngData(),
                            //archiveTag: "#2024-2",
                            //audioNote: nil,
                            phraseToRemember: "Connection interrupted: will attempt to reconnect",
                            translation: "Соединение прервано: будет предпринята попытка восстановить",
                            lastRepetition: Date(),
                            sources: [Source(title: "Xcode", color: .blue), Source(title: "Xcode", color: .purple)],
                            transcription: "ejfiwje",
                            status: .input),
                 geometry: geometry)
    }
}


