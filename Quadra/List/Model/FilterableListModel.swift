//
//  FilterableListModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 08/06/2024.
//

import Foundation
import Combine

final class FilterableListModel: ObservableObject {
    @Published var selectedStatuses = [Status]()
    @Published var selectedSources = [CardSource]()
    @Published var selectedArchiveTags = [CardArchiveTag]()
    @Published var fromDate = Date()
    @Published var toDate = Date()
    @Published var minDate = Date()
    @Published var maxDate = Date()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupDates()
        observeCardServiceChanges()
    }
    
    func setupDates() {
        let cards = CardService.shared.cards
        
        fromDate = cards.compactMap({ $0.additionTime }).min() ?? Date()
        toDate = cards.compactMap({ $0.additionTime }).max() ?? Date()
        minDate = cards.compactMap({ $0.additionTime }).min() ?? Date()
        maxDate = cards.compactMap({ $0.additionTime }).max() ?? Date()
    }
    
    
    func reset() {
        selectedStatuses = []
        selectedSources = []
        selectedArchiveTags = []
        setupDates()
    }
    
    func toggleStatusSelection(status: Status) {
        toggleItem(item: status, in: &selectedStatuses)
    }
    
    func toggleArchiveTagSelection(tag: CardArchiveTag) {
        toggleItem(item: tag, in: &selectedArchiveTags)
    }
    
    func toggleSourceSelection(source: CardSource) {
        toggleItem(item: source, in: &selectedSources)
    }
    
    private func toggleItem<T: Equatable & Identifiable>(item: T, in array: inout [T]) {
        if let index = array.firstIndex(where: { $0.id == item.id }) {
            array.remove(at: index)
        } else {
            array.append(item)
        }
    }

    private func observeCardServiceChanges() {
        CardService.shared.$cards
            .sink { [weak self] _ in
                self?.setupDates()
            }
            .store(in: &cancellables)
    }
}
