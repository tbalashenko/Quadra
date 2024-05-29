//
//  FilterView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 27/03/2024.
//

import SwiftUI

final class FilterViewModel: ObservableObject {
    @Published var sources = [CardSource]()
    @Published var selectedSources = [CardSource]() {
        didSet {
            setFilteredSources()
        }
    }
    @Published var filteredSources = [CardSource]()
    @Published var filteredArchiveTags = [CardArchiveTag]()
    @Published var selectedArchiveTags = [CardArchiveTag]() {
        didSet {
            setFilteredArchiveTags()
        }
    }
    @Published var archiveTags = [CardArchiveTag]()
    @Published var selectedStatuses = [Status]()
    @Published var minDate: Date = Date()
    
    @Published var fromDate: Date = Date() {
        didSet {
            isDateSetFromFilter = true
        }
    }
    @Published var toDate: Date = Date() {
        didSet {
            isDateSetFromFilter = true
        }
    }
    @Published private var modifiedSources: [CardSource] = []
    @Published var isDateSetFromFilter: Bool = false
    
    init() {
        setFilteredArchiveTags()
        setFilteredSources()
    }
    
    func removeFromSelectedSources(id: UUID) {
        guard let source = sources.first(where: { $0.id == id }) else { return }
        
        selectedSources.removeAll { $0 == source }
    }
    
    func appendSource(id: UUID) {
        guard let source = sources.first(where: { $0.id == id }) else { return }
        
        selectedSources.append(source)
    }
    
    func resetFilter() {
        selectedArchiveTags = []
        selectedSources = []
        selectedStatuses = []
        fromDate = minDate
        toDate = Date()
    }
    
    func setFilteredArchiveTags() {
        if selectedArchiveTags.isEmpty {
            filteredArchiveTags = archiveTags
        } else {
            filteredArchiveTags = archiveTags.filter { !selectedArchiveTags.contains($0) }
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
}

struct FilterView: View {
    @StateObject var viewModel = FilterViewModel()
    @Environment(\.dismiss) var dismiss
    

    @State private var totalHeight = CGFloat.infinity
    
    @State var filteredArchiveTags = [CardArchiveTag]()
    var archiveTags: [CardArchiveTag]
    
    var body: some View {
        GeometryReader { geometry in
            List {
                statusSection()
                creationDateSection()
                sourceSection(geometry: geometry)
                //archiveTagsSection(geometry: geometry)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.element)
            .navigationTitle("Filter")
            .toolbar {
                resetButton
            }
        }
    }
    
    private func statusSection() -> some View {
        GroupBox("Status") {
            HStack(spacing: 8) {
//                ForEach(Status.allStatuses, id: \.self) { status in
//                    TagView(text: status.title, 
//                            id: UUID(),
//                            backgroundColor: viewModel.selectedStatuses.contains(status) ? Color(hex: status.color) : .offWhiteGray) {_ in
//                        toggleStatus(status)
//                    }
//                }
            }
        }
        .styleListSection()
    }
    
    private func creationDateSection() -> some View {
        GroupBox("Creation Date") {
            DatePicker("From",
                       selection: $viewModel.fromDate,
                       displayedComponents: [.date])
            .datePickerStyle(.compact)
            DatePicker("To",
                       selection: $viewModel.toDate,
                       displayedComponents: [.date])
            .datePickerStyle(.compact)
        }
        .styleListSection()
    }
    
    @ViewBuilder
    private func sourceSection(geometry: GeometryProxy) -> some View {
        if !viewModel.sources.isEmpty {
            GroupBox("Sources") {
                if !viewModel.selectedSources.isEmpty {
//                    TagCloudView(totalHeight: $totalHeight, items: viewModel.selectedSources.map { TagCloudItem(id: $0.id, title: $0.title, color: $0.color) },
//                                 geometry: geometry
//                                 //action: { viewModel.removeFromSelectedSources(id: $0)
//                    )
                }
                
                if !viewModel.filteredSources.isEmpty {
//                    TagCloudView(totalHeight: $totalHeight, items: viewModel.filteredSources.map { TagCloudItem(id: $0.id, title: $0.title, color: $0.color) },
//                                 geometry: geometry,
//                                 inactiveColor: Color.offWhiteGray
//                                 //action: { viewModel.appendSource(id: $0) }
//                    )
                }
            }
            .styleListSection()
        }
    }
    
//    @ViewBuilder
//    private func archiveTagsSection(geometry: GeometryProxy) -> some View {
//        if !archiveTags.isEmpty {
////            let selectedItems = viewModel.selectedArchiveTags.map { TagCloudItem(id: $0.id, title: $0.title, color: $0.color) }
////            let filteredItems = viewModel.filteredArchiveTags.map { TagCloudItem(id: $0.id, title: $0.title, color: Color.offWhiteGray.toHex()) }
//#warning("Replace")
////            GroupBox("Archive tags") {
////                if !selectedItems.isEmpty {
////                    TagCloudView(
////                        totalHeight: $totalHeight, items: selectedItems,
////                        geometry: geometry
////                        //action: { print($0) }
////                        //action: { viewModel.selectedArchiveTags.remove(at: $0) }
////                    )
////                }
////#warning("Replace")
////                if !filteredItems.isEmpty {
////                    TagCloudView(
////                        totalHeight: $totalHeight, items: filteredItems,
////                        geometry: geometry,
////                        inactiveColor: Color.offWhiteGray
////                        //action: { print($0) }
////                        //action: { viewModel.selectedArchiveTags.append(filteredArchiveTags[$0]) }
////                    )
////                }
//            }
//            .styleListSection()
//        }
//    }
    
    private var resetButton: some View {
        Button {
            viewModel.resetFilter()
        } label: {
            Text("Reset")
        }
    }
    
    func toggleStatus(_ status: Status) {
        if viewModel.selectedStatuses.contains(status) {
            viewModel.selectedStatuses.removeAll { $0 == status }
        } else {
            viewModel.selectedStatuses.append(status)
        }
    }
}

// #Preview {
//    FilterView(selectedStatuses: .constant(Status.allStatuses),
//               fromDate: .constant(Date()),
//               toDate: .constant(Date()))
// }
