//
//  CreateCardView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/03/2024.
//

import SwiftUI
import PhotosUI
import CoreData

final class SetupCardViewModel: ObservableObject {
    @Published var cardModel: CardModel
    @Published var filteredSources = [CardSource]()
    @Published var selectedSources = Set<CardSource>() {
        didSet {
            filterSources()
        }
    }
    @Published var phraseToRemember = AttributedString()
    @Published var translation = AttributedString()
    @Published var transcription = ""
    @Published var newSourceText = "" {
        didSet {
            filterSources()
        }
    }
    
    var mode: SetupCardViewMode
    let sourceService = CardSourceService.shared
    
    //private var cards = [Card]()
    private var sources = [CardSource]()
    private var archiveTags = [CardArchiveTag]()
    private var statData = [StatData]()
    
    init(cardModel: CardModel, mode: SetupCardViewMode) {
        self.mode = mode
        self.cardModel = cardModel
        
        //fetchCards()
        fetchSources()
        fetchStatData()
        fetchArchiveTags()
        filteredSources = sources
        phraseToRemember = AttributedString(cardModel.card.phraseToRemember)
        translation = AttributedString(cardModel.card.translation ?? NSAttributedString(string: ""))
        transcription = cardModel.card.transcription ?? ""
        if let sources = cardModel.card.sources?.allObjects as? [CardSource] {
            selectedSources = Set(sources)
        }
        filterSources()
    }
    
//    func fetchCards() {
//        do {
//            cards = try CardService.shared.fetchCards()
//        } catch {
//            print("Error fetching cards: \(error.localizedDescription)")
//        }
//    }
    
    func fetchSources() {
        do {
            sources = try sourceService.fetchSources()
        } catch {
            print("Failed to fetch sources: \(error.localizedDescription)")
        }
    }
    
    func fetchStatData() {
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        do {
            statData = try StatDataService.shared.fetchStatData(sortDescriptors: [sortDescriptor])
        } catch {
            print("Error fetching statData: \(error.localizedDescription)")
        }
    }
    
    func fetchArchiveTags() {
        do {
            archiveTags = try ArchiveTagService.shared.fetchArchiveTags()
        } catch {
            print("Error fetching archive tags: \(error.localizedDescription)")
        }
    }
    
    @MainActor 
    func saveCard(image: Image?) {
        let image = image?.convert(scale: SettingsManager.shared.imageScale)
        
        do {
            let card = try CardService.shared.editCard(
                card: cardModel.card,
                phraseToRemember: NSAttributedString(phraseToRemember),
                translation: NSAttributedString(translation),
                transcription: transcription,
                imageData: image?.pngData(),
                sources: Array(selectedSources)
            )
        } catch {
            print("Error editing card: \(error.localizedDescription)")
        }
        StatDataService.shared.incrementAddedItemsCounter()
    }
    
    func saveSource(color: Color) {
        let hashTagTitle = "#" + newSourceText.replacingOccurrences(of: "#", with: "")
        
        do {
            let source = try sourceService.saveSource(title: hashTagTitle, color: color.toHex())
            selectedSources.insert(source)
            newSourceText = ""
        } catch {
            print("Error saving source: \(error.localizedDescription)")
        }
    }
    
    func filterSources() {
        let selectedSourceIDs = Set(selectedSources.map { $0.id })
        if newSourceText.isEmpty {
            filteredSources = Array(sources)
                .filter { !selectedSourceIDs.contains($0.id) }
        } else {
            filteredSources = Array(sources)
                .filter { $0.title.localizedCaseInsensitiveContains(newSourceText) }
                .filter { !selectedSourceIDs.contains($0.id) }
        }
    }
    
    func addToSelectedSources(sourceIndex: Int) {
        selectedSources.insert(filteredSources[sourceIndex])
    }
    
    func deleteCard() {
        do {
            try CardService.shared.delete(card: cardModel.card)
        } catch {
            print("Error deleting card: \(error.localizedDescription)")
        }
    }
}

enum SetupCardViewMode {
    case create, edit
    
    var navigationTitle: String {
        switch self {
            case .create:
                return "Add a new card"
            case .edit:
                return "Edit your card"
        }
    }
}

struct SetupCardView: View {
    @StateObject var viewModel: SetupCardViewModel
    @Binding var showSetupCardView: Bool
    let settingsManager = SettingsManager.shared
    
    @State private var totalHeight: CGFloat = CGFloat.infinity
    @State var image: Image?
    @State var sourceColor = Color.morningBlue
    
    var body: some View {
        GeometryReader { geometry in
            List {
                PhotoPickerView(image: $image)
                    .styleListSection()
                    .frame(
                        width: geometry.size.width * 0.9,
                        height: geometry.size.width * 0.9 * settingsManager.aspectRatio.ratio)
                
                phraseSection()
                sourcesSection(geometry: geometry)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.element)
            .onAppear {
                setup()
            }
            .navigationTitle(viewModel.mode.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        hideKeyboard()
                        viewModel.saveCard(image: image)
                        showSetupCardView = false
                    }
                    .disabled(viewModel.phraseToRemember.characters.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showSetupCardView = false
                        viewModel.deleteCard()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func phraseSection() -> some View {
        GroupBox("Phrase to remember*") {
            HighlightableTextView(text: $viewModel.phraseToRemember)
        }
        .styleListSection()
        .groupBoxStyle(PlainGroupBoxStyle())
        
        GroupBox("Translation") {
            HighlightableTextView(text: $viewModel.translation)
        }
        .styleListSection()
        .groupBoxStyle(PlainGroupBoxStyle())
        
        GroupBox("Transcription") {
            TextField(
                "",
                text: $viewModel.transcription,
                axis: .vertical)
            .textFieldStyle(NeuTextFieldStyle(text: $viewModel.transcription))
        }
        .styleListSection()
        .groupBoxStyle(PlainGroupBoxStyle())
    }
    
    private func sourcesSection(geometry: GeometryProxy) -> some View {
        GroupBox("Sources") {
            if !viewModel.selectedSources.isEmpty {
                Text("Selected sources:")
                    .foregroundStyle(Color.gray)
                TagCloudView(
                    items: viewModel.selectedSources.sorted(),
                    geometry: geometry,
                    totalHeight: $totalHeight,
                    action: { viewModel.selectedSources.remove(viewModel.selectedSources.sorted()[$0]) })
                Text("Tap to remove")
                    .font(.footnote)
                    .foregroundStyle(Color.gray)
            }
            HStack {
                ColorPicker("", selection: $sourceColor)
                    .frame(width: 22, height: 22)
                    .northWestShadow()
                
                TextField("Add a new source", text: $viewModel.newSourceText)
                    .textFieldStyle(NeuTextFieldStyle(text: $viewModel.newSourceText))
                    .padding(.horizontal)
                Button(action: {
                    if !viewModel.newSourceText.isEmpty {
                        hideKeyboard()
                        viewModel.saveSource(color: sourceColor)
                        sourceColor = .morningBlue
                    }
                }, label: {
                    Image(systemName: "plus")
                })
                .buttonStyle(NeuButtonStyle(width: 38, height: 38))
                .disabled(viewModel.newSourceText.isEmpty)
            }
            
            TagCloudView(
                max: 10,
                items: viewModel.filteredSources.sorted(),
                geometry: geometry,
                totalHeight: $totalHeight,
                action: {
                    viewModel.addToSelectedSources(sourceIndex: $0)
                    hideKeyboard()
                })
        }
        .styleListSection()
        .groupBoxStyle(PlainGroupBoxStyle())
    }
    
    private func setup() {
        if let imageData = viewModel.cardModel.card.image,
           let uiImage = UIImage(data: imageData) {
            image = Image(uiImage: uiImage)
        }
    }
}

//#Preview {
//    CreateCardView(showSetupCardView: .constant(true))
//}
