//
//  CreateCardView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/03/2024.
//

import SwiftUI
import PhotosUI
import CoreData

enum SetupCardViewMode {
    case create, edit
}

struct SetupCardView: View {
    @EnvironmentObject var dataController: DataController
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
    @FetchRequest(sortDescriptors: []) var sources: FetchedResults<ItemSource>
    @FetchRequest(sortDescriptors: []) var archiveTags: FetchedResults<ItemArchiveTag>
    @FetchRequest(sortDescriptors: []) var statData: FetchedResults<StatData>
    
    var setupCardViewMode: SetupCardViewMode
    var item: Item?
    
    @State private var totalHeight: CGFloat = CGFloat.infinity
    @State var filteredSources = [ItemSource]()
    @State var image: Image?
    @State var phraseToRemember = ""
    @State var translation = ""
    @State var transcription = ""
    @State var selectedSources = Set<ItemSource>()
    @State var newSourceText = ""
    @State var sourceColor = Color.morningBlue
    @Binding var showSetupCardView: Bool
    @State private var selectedSourceIndex = 0
    
    var body: some View {
        GeometryReader { geometry in
            List {
                PhotoPickerView(
                    ratio: settingsManager.aspectRatio.ratio,
                    image: $image)
                .frame(height: geometry.size.width * settingsManager.aspectRatio.ratio)
                .padding(.horizontal)
                .styleListSection()
                
                phraseSection()
                sourcesSection(geometry: geometry)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.element)
            .onAppear {
                filteredSources = Array(sources)
                
                guard let item = item else { return }
                
                setup(from: item)
            }
            .navigationTitle(setupCardViewMode == .create ? "Add a new card" : "Edit your card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .disabled(phraseToRemember.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showSetupCardView = false
                    }
                }
            }
        }
    }
    
    private func phraseSection() -> some View {
        GroupBox("Phrase") {
            TextField(
                "Phrase to remember*",
                text: $phraseToRemember,
                axis: .vertical)
            .textFieldStyle(NeuTextFieldStyle(text: $phraseToRemember))
            
            TextField(
                "Translation",
                text: $translation,
                axis: .vertical)
            .textFieldStyle(NeuTextFieldStyle(text: $translation))
            
            TextField(
                "Transcription",
                text: $transcription,
                axis: .vertical)
            .textFieldStyle(NeuTextFieldStyle(text: $transcription))
        }
        .styleListSection()
    }
    
    private func sourcesSection(geometry: GeometryProxy) -> some View {
        GroupBox("Sources") {
            if !selectedSources.isEmpty {
                Text("Selected sources:")
                    .foregroundStyle(Color.gray)
                TagCloudView(items: selectedSources.sorted(),
                             geometry: geometry,
                             totalHeight: $totalHeight,
                             action: { selectedSources.remove(selectedSources.sorted()[$0]) })
                Text("Tap to remove")
                    .font(.footnote)
                    .foregroundStyle(Color.gray)
            }
            HStack {
                ColorPicker("", selection: $sourceColor)
                    .frame(width: 22, height: 22)
                    .northWestShadow()
                
                TextField("Add a new source", text: $newSourceText)
                    .textFieldStyle(NeuTextFieldStyle(text: $newSourceText))
                    .padding(.horizontal)
                    .onChange(of: newSourceText) { _, _ in
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
                
                Button(action: {
                    if !newSourceText.isEmpty {
                        hideKeyboard()
                        saveSource()
                    }
                }, label: {
                    Image(systemName: "plus")
                })
                .buttonStyle(NeuButtonStyle(width: 38, height: 38))
                .disabled(newSourceText.isEmpty)
                .onChange(of: selectedSources) { _, _ in
                    let selectedSourceIDs = Set(selectedSources.map { $0.id })
                    filteredSources = Array(sources)
                        .filter { !selectedSourceIDs.contains($0.id) }
                }
            }
            
            TagCloudView(
                max: 10,
                items: filteredSources.sorted(),
                geometry: geometry,
                totalHeight: $totalHeight,
                action: {
                    selectedSources.insert(filteredSources.sorted()[$0])
                    hideKeyboard()
                })
        }
        .styleListSection()
    }
    
    private func setup(from item: Item) {
        if let imageData = item.image,
           let uiImage = UIImage(data: imageData) {
            image = Image(uiImage: uiImage)
        }
        phraseToRemember = item.phraseToRemember
        if let translation = item.translation {
            self.translation = translation
        }
        if let transcription = item.transcription {
            self.transcription = transcription
        }
        
        if let sources = item.sources?.allObjects as? [ItemSource] {
            selectedSources = Set(sources)
        }

        let selectedSourceIDs = Set(selectedSources.map { $0.id })
        filteredSources = Array(sources)
            .filter { !selectedSourceIDs.contains($0.id) }
    }
    
    func save() {
        let image = image?.convert(scale: settingsManager.imageScale)
        
        switch setupCardViewMode {
            case .create:
                let item = Item(context: viewContext)
                
                item.phraseToRemember = phraseToRemember
                item.translation = translation
                item.transcription = transcription
                item.status = Status.input
                item.image = image?.pngData()
                item.id = UUID()
                item.additionTime = Date()
                
                saveArchiveTag(to: item)
                saveSources(to: item)
                saveStatData()
            case .edit:
                guard let item = item else { return }
                
                item.phraseToRemember = phraseToRemember
                item.translation = translation
                item.transcription = transcription
                item.image = image?.pngData()
                
                item.sources = nil
                
                saveSources(to: item)
        }
        
        try? viewContext.save()
        
        showSetupCardView = false
    }
    
    func saveSources(to item: Item) {
        sources.forEach {
            item.addToSources($0)
            $0.addToItems(item)
        }
    }
    
    func saveSource() {
        let source = ItemSource(context: viewContext)
        source.id = UUID()
        source.color = sourceColor.toHex()
        source.title = "#" + newSourceText
        
        try? viewContext.save()
        
        selectedSources.insert(source)
        newSourceText = ""
        sourceColor = .morningBlue
    }
    
    func saveArchiveTag(to item: Item) {
        if let tag = archiveTags.first(where: { $0.title == Date().prepareTag() }) {
            tag.addToItems(item)
        } else {
            let tag = ItemArchiveTag(context: viewContext)
            tag.id = UUID()
            tag.color = ItemArchiveTag.getColor(for: Date())
            tag.title = Date().prepareTag()
            tag.items = NSSet(array: [item])
        }
    }
    
    func saveStatData() {
        let currentDate = Date().formattedForStats()
        
        if let statData = statData.first(where: { $0.date == currentDate }) {
            statData.addedItemsCounter += 1
            statData.totalNumberOfCards = items.count + 1
        } else {
            let statData = StatData(context: viewContext)
            statData.date = currentDate ?? Date()
            statData.addedItemsCounter += 1
            statData.totalNumberOfCards = items.count + 1
        }
    }
}

//#Preview {
//    CreateCardView(showSetupCardView: .constant(true))
//}
