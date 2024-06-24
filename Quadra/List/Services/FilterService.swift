//
//  FilterService.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 24/06/2024.
//

import Foundation
import Combine

final class FilterService: ObservableObject {
    static let shared = FilterService()
    
    @Published var selectedStatuses = [CardStatus]()
    @Published var selectedSources = [CardSource]()
    @Published var selectedArchiveTags = [CardArchiveTag]()
    @Published var fromDate = Date()
    @Published var toDate = Date()
    @Published var minDate = Date()
    @Published var maxDate = Date()
    
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        observeCardServiceChanges()
    }
    
    func observeCardServiceChanges() {
        CardService.shared.$cards
            .sink { [weak self] _ in
                self?.setupDates()
            }
            .store(in: &cancellables)
    }
    
    func setupDates() {
        Task {
            await MainActor.run {
                let cards = CardService.shared.cards
                
                fromDate = cards.compactMap({ $0.additionTime }).min() ?? Date().addingTimeInterval(-1)
                toDate = cards.compactMap({ $0.additionTime }).max() ?? Date().addingTimeInterval(1)
                minDate = cards.compactMap({ $0.additionTime }).min() ?? Date()
                maxDate = cards.compactMap({ $0.additionTime }).max() ?? Date()
            }
        }
    }
    
    func reset() async {
        Task {
            await MainActor.run {
                selectedStatuses = []
                selectedSources = []
                selectedArchiveTags = []
                setupDates()
            }
        }
    }
    
    func toggleStatusSelection(status: CardStatus) {
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
}
