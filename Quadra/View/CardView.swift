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
    let id = UUID()
    
    @EnvironmentObject var settingsManager: SettingsManager
    @ObservedObject var item: Item
    
    let cardViewPresentationMode: CardViewPresentationMode
    var deleteAction: (() -> Void)?
    var moveButtonAction: (() -> Void)?
    
    let gridLayout: [GridItem] = [
        GridItem(.adaptive(minimum: 100, maximum: 300)),
        GridItem(.adaptive(minimum: 100, maximum: 300)),
        GridItem(.adaptive(minimum: 100, maximum: 300))
    ]
    
    @State private var showTranslation = false
    @State private var showAdditionalInfo = false
    @State private var totalHeight = CGFloat.infinity
    @State private var showFullImage: Bool = false
    @State private var showSetupCardView: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                imageView(geometry: geometry)
                phraseView()
                additionalInfoView(geometry: geometry)
            }
            .background(.element)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .northWestShadow()
            .toolbar {
                if cardViewPresentationMode == .view {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showSetupCardView = true
                        } label: {
                            Image(systemName: "pencil")
                        }
                    }
                }
            }
            .sheet(isPresented: $showSetupCardView ) {
                NavigationStack {
                    SetupCardView(
                        setupCardViewMode: .edit, 
                        item: item,
                        showSetupCardView: $showSetupCardView
                    )
                    .environmentObject(settingsManager)
                }
            }
            .onAppear {
                if cardViewPresentationMode == .view {
                    showAdditionalInfo = true
                }
            }
        }
    }
    
    @ViewBuilder
    private func imageView(geometry: GeometryProxy) -> some View {
        if let imageData = item.image,
           let uiImage = UIImage(data: imageData) {
            imageViewWithImage(uiImage, geometry: geometry)
        } else {
            imageViewWithoutImage(geometry: geometry)
        }
    }
    
    private func imageViewWithImage(_ uiImage: UIImage, geometry: GeometryProxy) -> some View {
        Button(action: {
            showFullImage.toggle()
        }) {
            ZStack {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, 
                           height: geometry.size.width * settingsManager.aspectRatio.ratio)
                    .clipped()
                    .northWestShadow()
                infoButtonIfNeeded()
                moveToButton()
            }
        }
        .frame(width: geometry.size.width,
               height: geometry.size.width * settingsManager.aspectRatio.ratio)
        .fullScreenCover(isPresented: $showFullImage) {
            FullImageView(image: uiImage)
        }
    }
    
    private func imageViewWithoutImage(geometry: GeometryProxy) -> some View {
        HStack {
            moveToButton()
            Spacer()
            infoButtonIfNeeded()
        }
        .frame(width: geometry.size.width,
               height: geometry.size.width * settingsManager.aspectRatio.ratio)
    }
    
    @ViewBuilder
    private func infoButtonIfNeeded() -> some View {
        if cardViewPresentationMode == .swipe {
            EdgeButtonView(image: Image(systemName: "info.circle.fill"), edge: .topRight) {
                showAdditionalInfo.toggle()
            }
        }
    }
    
    @ViewBuilder
    private func moveToButton() -> some View {
        if item.needSetNewStatus,
           !item.isArchived,
           cardViewPresentationMode == .swipe {
            moveButtonView()
        }
    }
    
    private func moveButtonView() -> some View {
        VStack {
            HStack {
                Button(action: {
                    moveButtonAction?()
                }) {
                    HStack {
                        Text("→").bold()
                        TagView(text: item.getNewStatus.title, 
                                backgroundColor: Color(hex: item.getNewStatus.color),
                                withShadow: false) {
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
    
    private func phraseView() -> some View {
        VStack(alignment: .center) {
            if !showTranslation {
                phraseToRememberView()
            } else if let translation = item.translation {
                translationView(translation: translation)
            }
        }
    }
    
    private func translationView(translation: String) -> some View {
        Text(translation)
            .font(.title2)
            .bold()
            .padding()
            .onTapGesture {
                toggleTranslationVisibility()
            }
    }
    
    private func phraseToRememberView() -> some View {
        HStack(spacing: 12) {
            TextToSpeechPlayView(text: item.phraseToRemember,
                                 buttonSize: .small)
            .environmentObject(settingsManager)
            Text(item.phraseToRemember)
                .font(.title2)
                .bold()
                .onTapGesture {
                    toggleTranslationVisibility()
                }
        }
        .padding()
    }
    
    private func toggleTranslationVisibility() {
        if let translation = item.translation, !translation.isEmpty {
            showTranslation.toggle()
        }
    }
    
    @ViewBuilder
    private func additionalInfoView(geometry: GeometryProxy) -> some View {
        if showAdditionalInfo {
            additionalInfoContentView(geometry: geometry)
        }
    }
    
    private func additionalInfoContentView(geometry: GeometryProxy) -> some View {
        Group {
            transcriptionView()
            tagCloudView(geometry: geometry)
            repetitionInfoView()
        }
    }
    
    @ViewBuilder
    private func transcriptionView() -> some View {
        if let transcripton = item.transcription, 
            !transcripton.isEmpty {
            Text("[" + transcripton + "]")
        }
    }
    
    private func tagCloudView(geometry: GeometryProxy) -> some View {
        var items = [TagCloudViewItem]()
        if item.status.id == 3 {
            items.append(TagCloudItem(title: item.archiveTag, color: Color.puce.toHex()))
        }
        
        items.append(TagCloudItem(title: item.status.title, color: item.status.color))
        
        if let sources = item.sources?.allObjects as? [ItemSource] {
            items.append(contentsOf: sources)
        }
        return TagCloudView(
            items: items,
            geometry: geometry,
            totalHeight: $totalHeight)
        .padding(.vertical)
    }
    
    private func repetitionInfoView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            styledText("Added: ", regularPart: item.additionTime.formatDate())
            styledText("Number of repetitions: ", regularPart: String(item.repetitionCounter))
            if let lastRepetition = item.lastRepetition {
                styledText("Last repetition: ", regularPart: lastRepetition.formatDate())
            }
        }
    }
    
    private func styledText(_ boldPart: String, regularPart: String) -> Text {
        let boldText = Text(boldPart).bold()
        let regularText = Text(regularPart)
        return boldText + regularText
    }
}

#Preview {
    GeometryReader { geometry in
        CardView(item: Item(image: nil, archiveTag: "Test", phraseToRemember: "Test", translation: "Test1", lastRepetition: Date(), sources: [ItemSource.source1], transcription: nil, additionTime: Date(), status: .archive), cardViewPresentationMode: .view)
    }
}


