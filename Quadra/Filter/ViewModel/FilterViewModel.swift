//
//  FilterViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 08/06/2024.
//

import Foundation

final class FilterViewModel: ObservableObject {
    @Published var model: FilterableListModel
    @Published var statusTags: [TagCloudItem] = []
    @Published var archiveTags: [TagCloudItem] = []
    @Published var sourceTags: [TagCloudItem] = []
    
    init(model: FilterableListModel) {
        self.model = model
        setupStatusTags()
        setupArchiveTags()
        setupSourceTags()
    }
    
    func resetFilter() {
        model.reset()
        setupStatusTags()
        setupArchiveTags()
        setupSourceTags()
    }
    
    private func setupStatusTags() {
        statusTags.removeAll()
        
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
            statusTags.append(item)
        }
    }
    
    private func setupArchiveTags() {
        archiveTags.removeAll()
        
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
            archiveTags.append(item)
        }
    }
    
    private func setupSourceTags() {
        sourceTags.removeAll()
        
        CardSourceService.shared.sources.forEach { source in
            let item = TagCloudItem(
                isSelected: model.selectedSources.contains(source),
                id: source.id,
                title: source.title,
                color: source.color,
                action: { [weak self] in
                    self?.model.toggleSourceSelection(source: source)
                }
            )
            sourceTags.append(item)
        }
    }
}
