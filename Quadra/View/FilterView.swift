//
//  FilterView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 27/03/2024.
//

import SwiftUI

struct FilterView: View {
    @FetchRequest(sortDescriptors: []) var sources: FetchedResults<ItemSource>
    @EnvironmentObject var dataManager: CardManager
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    @Binding var selectedStatuses: [Status]
    @Binding var selectedArchiveTags: [String]
    @Binding var fromDate: Date
    @Binding var toDate: Date
    @Binding var selectedSources: [ItemSource]
    @Binding var minDate: Date
    @State private var totalHeight = CGFloat.infinity
    @State private var modifiedSources: [ItemSource] = []
    @State var filteredSources = [ItemSource]()
    @State var filteredArchiveTags = [String]()
    var archiveTags: [String]
    
    var body: some View {
        GeometryReader { geometry in
            Form {
                statusSection()
                creationDateSection()
                sourceSection(geometry: geometry)
                archiveTagsSection(geometry: geometry)
            }
            .scrollContentBackground(.hidden)
            .background(Color.element)
            .navigationTitle("Filter")
            .onAppear {
                setFilteredSources()
                setFilteredArchiveTags()
            }
            .onChange(of: selectedSources) {
                setFilteredSources()
            }
            .onChange(of: selectedArchiveTags) {
                setFilteredArchiveTags()
            }
            .toolbar {
                resetButton
            }
        }
    }
    
    private func statusSection() -> some View {
        GroupBox("Status") {
            HStack(spacing: 8) {
                ForEach(Status.allStatuses, id: \.self) { status in
                    TagView(text: status.title,
                            backgroundColor: selectedStatuses.contains(status) ? Color(hex: status.color) : .offWhiteGray) {
                        toggleStatus(status)
                    }
                }
            }
        }
        .styleFormSection()
    }
    
    private func creationDateSection() -> some View {
        GroupBox("Creation Date") {
            DatePicker("From",
                       selection: $fromDate,
                       displayedComponents: [.date])
            .datePickerStyle(.compact)
            DatePicker("To",
                       selection: $toDate,
                       displayedComponents: [.date])
            .datePickerStyle(.compact)
        }
        .styleFormSection()
    }
    
    @ViewBuilder
    private func sourceSection(geometry: GeometryProxy) -> some View {
        if !sources.isEmpty {
            GroupBox("Sources") {
                if !selectedSources.isEmpty {
                    TagCloudView(items: selectedSources,
                                 geometry: geometry,
                                 totalHeight: $totalHeight,
                                 action: { selectedSources.remove(at: $0)
                    })
                }
                
                if !filteredSources.isEmpty {
                    TagCloudView(items: filteredSources,
                                 geometry: geometry,
                                 totalHeight: $totalHeight,
                                 inactiveColor: Color.offWhiteGray,
                                 action: { selectedSources.append(filteredSources[$0]) })
                }
            }
            .styleFormSection()
        }
    }
    
    @ViewBuilder
    private func archiveTagsSection(geometry: GeometryProxy) -> some View {
        if !archiveTags.isEmpty {
            let selectedItems = selectedArchiveTags.map { TagCloudItem(title: $0, color: Color.puce.toHex()) }
            let filteredItems = filteredArchiveTags.map { TagCloudItem(title: $0, color: Color.puce.toHex()) }
            
            GroupBox("Archive tags") {
                if !selectedItems.isEmpty {
                    TagCloudView(
                        items: selectedItems,
                        geometry: geometry,
                        totalHeight: $totalHeight,
                        action: { selectedArchiveTags.remove(at: $0) }
                    )
                }
                
                if !filteredItems.isEmpty {
                    TagCloudView(
                        items: filteredItems,
                        geometry: geometry,
                        totalHeight: $totalHeight,
                        inactiveColor: Color.offWhiteGray,
                        action: { selectedArchiveTags.append(filteredArchiveTags[$0]) }
                    )
                }
            }
            .styleFormSection()
        }
    }
    
    private var resetButton: some View {
        Button {
            selectedArchiveTags = []
            selectedSources = []
            selectedStatuses = []
            fromDate = minDate
            toDate = Date()
        } label: {
            Text("Reset")
        }
    }
    
    func toggleStatus(_ status: Status) {
        if selectedStatuses.contains(status) {
            selectedStatuses.removeAll { $0 == status }
        } else {
            selectedStatuses.append(status)
        }
    }
    
    func setFilteredSources() {
        if !selectedSources.isEmpty {
            filteredSources = sources.filter { source in
                !selectedSources.contains(where: { $0.id == source.id })
            }
        } else {
            filteredSources = Array(sources)
        }
    }
    
    func setFilteredArchiveTags() {
        if selectedArchiveTags.isEmpty {
            filteredArchiveTags = archiveTags
        } else {
            filteredArchiveTags = archiveTags.filter { !selectedArchiveTags.contains($0) }
        }
    }
}

// #Preview {
//    FilterView(selectedStatuses: .constant(Status.allStatuses),
//               fromDate: .constant(Date()),
//               toDate: .constant(Date()))
// }
