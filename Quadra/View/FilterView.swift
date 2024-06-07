//
//  FilterView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 27/03/2024.
//

import SwiftUI
import Combine

final class FilterViewModel: ObservableObject {
    @Published var model: FilterableListModel
    @Published var statusItems: [TagCloudItem] = []
    @Published var archiveItems: [TagCloudItem] = []
    
    
    private var cancellables = Set<AnyCancellable>()
    
    init(model: FilterableListModel) {
        self.model = model
        setupStatusTagItems()
        setupArchiveItems()
    }
    
    func setupStatusTagItems() {
        statusItems.removeAll()
        
        Status.allStatuses.forEach { status in
            let item = TagCloudItem(
                isSelected: model.selectedStatuses.contains(status),
                id: UUID(uuidString: status.title) ?? UUID(),
                title: status.title,
                color: status.color,
                action: { [weak self] in
                    self?.model.toggleStatusSelection(status: status)
                }
            )
            statusItems.append(item)
        }
    }
    
    
    func setupArchiveItems() {
        archiveItems.removeAll()
        
        ArchiveTagService.shared.archiveTags.forEach { tag in
            let item = TagCloudItem(
                isSelected: model.selectedArchiveTags.contains(tag),
                id: tag.id,
                title: tag.title,
                color: tag.color,
                action: { [weak self] in
                    self?.model.toggleArchiveTagSelection(tag: tag)
                }
            )
            archiveItems.append(item)
        }
    }
    //
    //    func removeFromSelectedSources(id: UUID) {
    //        guard let source = sources.first(where: { $0.id == id }) else { return }
    //
    //        selectedSources.removeAll { $0 == source }
    //    }
    //
    //    func appendSource(id: UUID) {
    //        guard let source = sources.first(where: { $0.id == id }) else { return }
    //
    //        selectedSources.append(source)
    //    }
    //
    //    func resetFilter() {
    //        selectedArchiveTags = []
    //        selectedSources = []
    //        selectedStatuses = []
    //        fromDate = minDate
    //        toDate = Date()
    //    }
    //
    //    func setFilteredArchiveTags() {
    //        if selectedArchiveTags.isEmpty {
    //            filteredArchiveTags = archiveTags
    //        } else {
    //            filteredArchiveTags = archiveTags.filter { !selectedArchiveTags.contains($0) }
    //        }
    //    }
    //
    //    func setFilteredSources() {
    //        if !selectedSources.isEmpty {
    //            filteredSources = sources.filter { source in
    //                !selectedSources.contains(where: { $0.id == source.id })
    //            }
    //        } else {
    //            filteredSources = Array(sources)
    //        }
    //    }
}

struct FilterView: View {
    @StateObject var viewModel: FilterViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            List {
                statusSection()
                creationDateSection()
                //sourceSection(geometry: geometry)
                ArchiveTagsFilterView(viewModel: viewModel)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.element)
            .navigationTitle("Filter")
            .toolbar {
                //resetButton
            }
        }
    }
    
    private func statusSection() -> some View {
        GroupBox("Status") {
            TagCloudView(
                viewModel: TagCloudViewModel(
                    items: viewModel.statusItems,
                    isSelectable: true)
                )
        }
        .styleListSection()
    }
    
    private func creationDateSection() -> some View {
        GroupBox("Creation Date") {
            DatePicker("From",
                       selection: $viewModel.model.fromDate,
                       in: viewModel.model.minDate...viewModel.model.toDate,
                       displayedComponents: [.date])
            .datePickerStyle(.compact)
            DatePicker("To",
                       selection: $viewModel.model.toDate,
                       in: viewModel.model.fromDate...viewModel.model.maxDate,
                       displayedComponents: [.date])
            .datePickerStyle(.compact)
        }
        .styleListSection()
    }
}

struct ArchiveTagsFilterView: View {
    @ObservedObject var viewModel: FilterViewModel
    
    var body: some View {
        GroupBox("Archive Tags") {
            TagCloudView(
                viewModel: TagCloudViewModel(
                    items: viewModel.archiveItems,
                    isSelectable: true)
            )
        }
        .styleListSection()
    }
}

//    private var resetButton: some View {
//        Button {
//            viewModel.resetFilter()
//        } label: {
//            Text("Reset")
//        }
//    }
//

// #Preview {
//    FilterView(selectedStatuses: .constant(Status.allStatuses),
//               fromDate: .constant(Date()),
//               toDate: .constant(Date()))
// }
