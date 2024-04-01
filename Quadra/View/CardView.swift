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

    var geometry: GeometryProxy
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
            VStack {
                ZStack {
                    if let data = item.image,
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width,
                                   height: geometry.size.height * 1/2)
                            .clipped()
                            .northWestShadow()
                    }

                    if presentationMode == .swipe {
                        EdgeButtonView(image: Image(systemName: "info.circle.fill"),
                                       edge: .topRight,
                                       action: { showAdditionalInfo.toggle()
                        })
                    }

                    VStack {
                        Spacer()
                        HStack(spacing: 8) {
                            Spacer()
                            if item.status.id == 3 {
                                TagView(text: item.archiveTag,
                                        backgroundColor: .puce)
                            }
                            TagView(text: item.status.title,
                                    backgroundColor: Color(hex: item.status.color))
                        }
                    }
                    .padding()
                }
                .frame(width: geometry.size.width,
                       height: geometry.size.height * 1/2)

                Text(!showTranslation ? (item.phraseToRemember ) : item.translation ?? "refewf")
                    .font(.title2)
                    .bold()
                    .padding()
                    .onTapGesture { showTranslation.toggle() }

                if !showTranslation, let transcripton = item.transcription {
                    Text("[" + transcripton + "]")
                }

                if showAdditionalInfo {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            if let sources = item.sources?.allObjects as? [Source] {
                                TagCloudView(items: sources, geometry: geometry, totalHeight: $totalHeight)
                            }
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
                if item.needSetNewStatus, !item.isArchived, presentationMode == .swipe {
                    Button {
                        moveButtonAction?()
                    } label: {
                        HStack {
                            Text("Move to")
                            TagView(text: item.getNewStatus.title,
                                    backgroundColor: Color(hex: item.getNewStatus.color)) {
                                moveButtonAction?()
                            }
                        }
                    }
                    .buttonStyle(NeuButtonStyle(width: geometry.size.width / 2, height: 40))

                }
                Spacer()
            }
            .background(.element)
            .cornerRadius(8)
            .northWestShadow()
            .onAppear {
                if presentationMode == .view {
                    showAdditionalInfo = true
                }
            }
        }
    }

    func styledText(_ boldPart: String, regularPart: String) -> Text {
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

// #Preview {
//    GeometryReader { geometry in
//        CardView(item: Item(image: UIImage(named: "test")?.pngData(),
//                            archiveTag: "#2024-2",
//                            //audioNote: nil,
//                            phraseToRemember: "Connection interrupted: will attempt to reconnect",
//                            translation: "Соединение прервано: будет предпринята попытка восстановить",
//                            lastRepetition: Date(),
//                            sources: [Source(title: "Xcode", color: .blue), Source(title: "Xcode", color: .purple)],
//                            transcription: "ejfiwje",
//                            status: .input),
//                 geometry: geometry, presentationMode: .view)
//    }
// }
