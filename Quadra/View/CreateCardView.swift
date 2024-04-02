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
    @EnvironmentObject var manager: CardManager
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [])  var sources: FetchedResults<Source>
    @State private var totalHeight: CGFloat = CGFloat.infinity

    @State var filteredSources = [Source]()
    @State var photosPickerItem: PhotosPickerItem?
    @State var image: Image?
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
                VStack(alignment: .center, spacing: 8) {
                    PhotoPickerView(geometry: geometry,
                                    photosPickerItem: $photosPickerItem,
                                    image: $image) {
                        setImage()
                    }
                    GroupBox("Phrase") {
                        TextField("Phrase to remember*",
                                  text: $phraseToRemember,
                                  axis: .vertical)
                        .textFieldStyle(NeuTextFieldStyle())

                        TextField("Translation",
                                  text: $translation,
                                  axis: .vertical)
                        .textFieldStyle(NeuTextFieldStyle())

                        TextField("Transcription",
                                  text: $transcription,
                                  axis: .vertical)
                        .textFieldStyle(NeuTextFieldStyle())
                    }
                    .backgroundStyle(Color.element)

                    GroupBox("Source") {
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
                                .textFieldStyle(NeuTextFieldStyle())
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

                        TagCloudView(max: 10,
                                     items: filteredSources.sorted(),
                                     geometry: geometry,
                                     totalHeight: $totalHeight,
                                     action: {
                            selectedSources.insert(filteredSources.sorted()[$0])
                            hideKeyboard()
                        })
                    }
                    .backgroundStyle(Color.element)
                    Spacer()
                }
                .padding()
            }
            .background(.element)
            .onAppear {
                filteredSources = Array(sources)
            }
            .frame(width: geometry.size.width)
            .navigationTitle("Add a new card")
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
                        showCreateCardView = false
                    }
                }
            }
        }
    }

    func save() {
        let image = image?.convert()

        manager.createItem(phraseToRemember: phraseToRemember,
                           translation: translation,
                           transcription: transcription,
                           sources: selectedSources,
                           image: image)
        showCreateCardView = false
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
