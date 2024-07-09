//
//  FilterViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 08/06/2024.
//

import Foundation

final class FilterViewModel: ObservableObject {
    @Published var statusTags: [TagCloudItem] = []
    @Published var archiveTags: [TagCloudItem] = []
    @Published var sourceTags: [TagCloudItem] = []

    init() {
        Task {
            await setupStatusTags()
            await setupArchiveTags()
            await setupSourceTags()
        }
    }

    func resetFilter() {
        Task {
            await FilterService.shared.reset()
            await setupStatusTags()
            await setupArchiveTags()
            await setupSourceTags()
        }
    }

    @MainActor
    private func setupStatusTags() {
        statusTags.removeAll()
        
        CardStatus.allCases.forEach { status in
            let item = TagCloudItem(
                isSelected: FilterService.shared.selectedStatuses.contains(status),
                id: UUID(uuidString: String(status.id)) ?? UUID(),
                title: status.title,
                hexColor: status.hexColor,
                action: { FilterService.shared.toggleStatusSelection(status: status) }
            )
            statusTags.append(item)
        }
    }

    @MainActor
    private func setupArchiveTags() {
        archiveTags.removeAll()

        ArchiveTagService.shared.archiveTags.forEach { tag in
            let item = TagCloudItem(
                isSelected: FilterService.shared.selectedArchiveTags.contains(tag),
                id: tag.id,
                title: tag.title,
                hexColor: tag.color,
                action: { FilterService.shared.toggleArchiveTagSelection(tag: tag) }
            )
            archiveTags.append(item)
        }
    }

    @MainActor
    private func setupSourceTags() {
        sourceTags.removeAll()

        CardSourceService.shared.sources.forEach { source in
            let item = TagCloudItem(
                isSelected: FilterService.shared.selectedSources.contains(source),
                id: source.id,
                title: source.title,
                hexColor: source.color,
                action: { FilterService.shared.toggleSourceSelection(source: source) }
            )
            sourceTags.append(item)
        }
    }
}
