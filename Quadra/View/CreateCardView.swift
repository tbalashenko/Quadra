//
//  CreateCardView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/03/2024.
//

import SwiftUI
import PhotosUI
import CoreData

struct CreateCardView: View {
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])  var sources: FetchedResults<Source>
    @State private var totalHeight: CGFloat = CGFloat.infinity
    
    @State var filteredSources = [Source]()
    @State var photosPickerItem: PhotosPickerItem?
    @State var image: Image? = nil
    @State var phraseToRemember = ""
    @State var translation = ""
    @State var transcription = ""
    @State var selectedSources = Set<Source>()
    @State var newSourceText = ""
    @State var sourceColor = Color.morningBlue
    @Binding var showCreateCardView: Bool
    @State private var selectedSourceIndex = 0
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                PhotoPickerView(width: UIScreen.main.bounds.width - 32,
                                heigh: UIScreen.main.bounds.height / 3,
                                photosPickerItem: $photosPickerItem,
                                image: $image) {
                    setImage()
                }
                                .padding()
                
                TextField("Phrase to remember", text: $phraseToRemember, axis: .vertical)
                    .textFieldStyle(NeuTextFieldStyle())
                TextField("Translation", text: $translation, axis: .vertical)
                    .textFieldStyle(NeuTextFieldStyle())
                TextField("Transcription", text: $transcription, axis: .vertical)
                    .textFieldStyle(NeuTextFieldStyle())
                
                if !selectedSources.isEmpty {
                    Text("Selected sources:")
                        .foregroundStyle(Color.gray)
                    TagCloudView(items: selectedSources.sorted(),
                                 geometry: geometry,
                                 action: { index in selectedSources.remove(selectedSources.sorted()[index])},
                                 totalHeight: $totalHeight)
                    Text("Tap to remove")
                        .font(.footnote)
                        .foregroundStyle(Color.gray)
                }
                
                if !selectedSources.isEmpty && !filteredSources.isEmpty {
                    Divider()
                }
                
                if !filteredSources.isEmpty {
                            Text("Suggested sources:")
                                .foregroundStyle(Color.gray)
                            TagCloudView(max: 10,
                                         items: filteredSources.sorted(),
                                         geometry: geometry,
                                         action: { index in selectedSources.insert(filteredSources.sorted()[index])},
                                         totalHeight: $totalHeight)
                            Text("Tap to add")
                                .font(.footnote)
                                .foregroundStyle(Color.gray)
                }
                
                HStack {
                    ColorPicker("", selection: $sourceColor)
                        .frame(width: 22, height: 22)
                        .northWestShadow()
                    TextField("Add New Source", text: $newSourceText)
                        .textFieldStyle(NeuTextFieldStyle())
                        .onChange(of: newSourceText) { _, _ in
                            let selectedSourceIDs = Set(selectedSources.map { $0.id })
                            if newSourceText.isEmpty {
                                filteredSources = Array(sources)
                                    .filter { !selectedSourceIDs.contains($0.id) }
                            } else {
                                filteredSources = Array(sources)
                                    .filter { $0.title?.localizedCaseInsensitiveContains(newSourceText) ?? false }
                                    .filter { !selectedSourceIDs.contains($0.id) }
                            }
                        }
                    
                    Button(action: {
                        if !newSourceText.isEmpty { saveSource() }
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
                .padding()
            }
        }
        .onAppear { filteredSources = Array(sources) }
        .background(.element)
        .navigationTitle("Add a new card")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    save()
                    showCreateCardView = false
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    showCreateCardView = false
                }
            }
        }
    }
    
    func save() {
        let image = image?.convert()
        
        let item = Item(context: self.viewContext)
        item.id = UUID()
        item.additionTime = Date()
        item.phraseToRemember = phraseToRemember
        item.translation = translation
        item.status = Status.input
        item.image = image?.pngData()
        item.sources = NSSet(set: selectedSources)
        
        
        do {
            try self.viewContext.save()
            print("Item saved!")
        } catch {
            print("whoops \(error.localizedDescription)")
        }
    }
    
    func saveSource() {
        let source = Source(context: self.viewContext)
        source.id = UUID()
        source.color = sourceColor.toHex()
        source.title = newSourceText
        
        selectedSources.insert(source)
        newSourceText = ""
        sourceColor = .morningBlue
        
        do {
            try self.viewContext.save()
            print("source saved!")
        } catch {
            print("whoops \(error.localizedDescription)")
        }
    }
    
    func setImage() {
        Task {
            if
                let data = try? await photosPickerItem?.loadTransferable(type: Data.self),
                let uiImage = UIImage(data: data) {
                image = Image(uiImage: uiImage)
                return
            }
        }
        image = nil
    }
}

#Preview {
    CreateCardView(showCreateCardView: .constant(true))
}
