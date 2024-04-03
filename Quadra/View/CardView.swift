//
//  CardView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/03/2024.
//

import SwiftUI

enum CardViewPresentationMode {
    case swipe, view
}

struct CardView: View {
    @ObservedObject var item: Item
    let id = UUID()
    let presentationMode: CardViewPresentationMode
    var deleteAction: (() -> Void)?
    var moveButtonAction: (() -> Void)?
    var gridLayout: [GridItem] = [ GridItem(.adaptive(minimum: 100, maximum: 300)),
                                   GridItem(.adaptive(minimum: 100, maximum: 300)),
                                   GridItem(.adaptive(minimum: 100, maximum: 300)) ]
    @State var showTranslation = false
    @State var showAdditionalInfo = false
    @State private var totalHeight = CGFloat.infinity
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                imageView(geometry: geometry)
                phraseView()
                tagCloudView(geometry: geometry)
                additionalInfoView()
            }
            .background(.element)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .northWestShadow()
            .onAppear {
                if presentationMode == .view {
                    showAdditionalInfo = true
                }
            }
        }
    }
    
    private func imageView(geometry: GeometryProxy) -> some View {
        return Group {
            if let data = item.image,
               let uiImage = UIImage(data: data) {
                ZStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width,
                               height: geometry.size.width * 9/16)
                        .clipped()
                        .northWestShadow()
                    
                    if presentationMode == .swipe {
                        EdgeButtonView(image: Image(systemName: "info.circle.fill"),
                                       edge: .topRight,
                                       action: { showAdditionalInfo.toggle()
                        })
                    }
                    
                    moveToButton()
                }
                
            } else {
                HStack {
                    moveToButton()
                    Spacer()
                    if presentationMode == .swipe {
                        EdgeButtonView(image: Image(systemName: "info.circle.fill"),
                                       edge: .topRight,
                                       action: { showAdditionalInfo.toggle()
                        })
                    }
                }
            }
        }
        .frame(width: geometry.size.width,
               height: geometry.size.width * 9/16)
    }
    
    private func moveToButton() -> some View {
        Group {
            if item.needSetNewStatus, !item.isArchived, presentationMode == .swipe {
                VStack {
                    HStack {
                        Button {
                            moveButtonAction?()
                        } label: {
                            HStack {
                                Text("→")
                                    .bold()
                                TagView(text: item.getNewStatus.title,
                                        backgroundColor: Color(hex: item.getNewStatus.color)) {
                                    moveButtonAction?()
                                }
                            }
                        }
                        .padding(4)
                        .buttonStyle(TransparentButtonStyle())
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
    }
    
    private func phraseView() -> some View {
        return Group {
            VStack(alignment: .center) {
                Text(!showTranslation ? (item.phraseToRemember ) : item.translation ?? "")
                    .font(.title2)
                    .bold()
                    .padding()
                    .onTapGesture {
                        if let translation = item.translation, !translation.isEmpty {
                            showTranslation.toggle()
                        }
                    }
                if !showTranslation, let transcripton = item.transcription {
                    Text("[" + transcripton + "]")
                }
            }
        }
    }
    
    private func tagCloudView(geometry: GeometryProxy) -> some View {
        var items = [TagCloudViewItem]()
        
        if item.status.id == 3 {
            items.append(TagCloudItem(title: item.archiveTag, color: Color.puce.toHex()))
        }
        
        items.append(TagCloudItem(title: item.status.title, color: item.status.color))
        
        if let sources = item.sources?.allObjects as? [Source] {
            items.append(contentsOf: sources)
        }
        
        return Group {
            TagCloudView(items: items, geometry: geometry, totalHeight: $totalHeight)
        }
    }
        
    private func additionalInfoView() -> some View {
        Group {
            if showAdditionalInfo {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        
                        styledText("Added: ", regularPart: formatDate(item.additionTime))
                        styledText("Number of repetitions: ", regularPart: String(item.repetitionCounter))
                        if let lastRepetition = item.lastRepetition {
                            styledText("Last repetition: ", regularPart: formatDate(lastRepetition))
                        }
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    private func styledText(_ boldPart: String, regularPart: String) -> Text {
        let boldText = Text(boldPart).bold()
        let regularText = Text(regularPart)
        return boldText + regularText
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
    
extension CardView: Identifiable { }

#Preview {
    GeometryReader { geometry in
        CardView(item: Item(image: nil, archiveTag: "Test", phraseToRemember: "Test", translation: "Test1", lastRepetition: Date(), sources: [Source.source1], transcription: nil, additionTime: Date(), status: .archive), presentationMode: .view)
    }
}
