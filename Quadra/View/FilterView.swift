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
    @State private var geometryProxy: GeometryProxy?
    var archiveTags: [String]
    
    var body: some View {
        GeometryReader { geometry in
            List {
                statusGroupBox
                creationDateGroupBox
                sourcesGroupBox
                archiveTagsGroupBox
            }
            .listStyle(.plain)
            .background(Color.element)
            .onAppear {
                setFilteredSources()
                setFilteredArchiveTags()
                geometryProxy = geometry
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
    
    private var statusGroupBox: some View {
        GroupBox("Status") {
            HStack(spacing: 8) {
                ForEach(Status.allStatuses, id: \.self) { status in
                    TagView(text: status.title,
                            backgroundColor: selectedStatuses.contains(status) ? Color(hex: status.color) : Color.offWhiteGray) {
                        toggleStatus(status)
                    }
                }
            }
        }
        .backgroundStyle(Color.element)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.element)
    }
    
    private var creationDateGroupBox: some View {
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
        .backgroundStyle(Color.element)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.element)
    }
    
    private var sourcesGroupBox: some View {
        Group {
            if !sources.isEmpty, let geometryProxy = geometryProxy {
                GroupBox("Sources") {
                    TagCloudView(items: selectedSources,
                                 geometry: geometryProxy,
                                 totalHeight: $totalHeight,
                                 action: { selectedSources.remove(at: $0)
                    })
                    .padding(selectedSources.isEmpty ? 0 : 4)
                    
                    TagCloudView(items: filteredSources,
                                 geometry: geometryProxy,
                                 totalHeight: $totalHeight,
                                 inactiveColor: Color.offWhiteGray,
                                 action: { selectedSources.append(filteredSources[$0]) })
                    .padding(filteredSources.isEmpty ? 0 : 4)
                }
                .backgroundStyle(Color.element)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.element)
            } else {
                EmptyView()
            }
        }
    }
    
    private var archiveTagsGroupBox: some View {
        Group {
            if !archiveTags.isEmpty, let geometryProxy = geometryProxy {
                let selectedItems = selectedArchiveTags.map { TagCloudItem(title: $0, color: Color.puce.toHex()) }
                let filteredItems = filteredArchiveTags.map { TagCloudItem(title: $0, color: Color.puce.toHex()) }
                
                GroupBox("Archive tags") {
                    TagCloudView(
                        items: selectedItems,
                        geometry: geometryProxy,
                        totalHeight: $totalHeight,
                        action: { selectedArchiveTags.remove(at: $0) }
                    )
                    .padding(selectedItems.isEmpty ? 0 : 4)
                    
                    TagCloudView(
                        items: filteredItems,
                        geometry: geometryProxy,
                        totalHeight: $totalHeight,
                        inactiveColor: Color.offWhiteGray,
                        action: { selectedArchiveTags.append(filteredArchiveTags[$0]) }
                    )
                    .padding(filteredItems.isEmpty ? 0 : 4)
                }
                .backgroundStyle(Color.element)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.element)
            } else {
                EmptyView()
            }
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
