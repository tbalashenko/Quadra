//
//  ListViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 08/06/2024.
//

import Foundation
import Combine

final class ListViewModel: ObservableObject {
    @Published var model = FilterableListModel()
    @Published var filteredCards: [Status: [Card]] = [:]
    @Published var searchText: String = ""
    @Published var isSearchPresented: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    var sortedStatuses: [Status] {
        return Status.allStatuses.filter { filteredCards.keys.contains($0) }
    }
    
    init() {
        filterCards()
        observeChanges()
        
        $filteredCards
            .map { !$0.values.isEmpty }
            .assign(to: &$isSearchPresented)
    }
    
    func observeChanges() {
            observeFilterableModelChanges()
            observeSearchTextChanges()
            observeCardServiceChanges()
        }
    
    func filterCards() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let cards = CardService.shared.cards
                .filter { card in
                    let textMatch = self.checkTextMatch(card: card)
                    let statusMatches = self.checkStatusMatches(card: card)
                    let sourceMatches = self.checkSourceMatches(card: card)
                    let dateRangeMatches = self.checkDateRangeMatches(card: card)
                    let archiveTagMatches = self.checkArchiveTagMatches(card: card)
                    
                    return textMatch && statusMatches && sourceMatches && dateRangeMatches && archiveTagMatches
                }
            self.filteredCards = Dictionary(grouping: cards, by: { $0.status })
        }
    }
    
    func delete(at offsets: IndexSet, from status: Status) {
        guard let index = offsets.first else { return }
        
        if let cards = filteredCards[status] {
            let card = cards[index]
            do {
                try CardService.shared.delete(card: card)
            } catch {
                print("Error deleting card \(error.localizedDescription)")
            }
        }
    }
}

extension ListViewModel {
    private func observeFilterableModelChanges() {
        Publishers.CombineLatest4(
            model.$selectedStatuses,
            model.$selectedSources,
            model.$selectedArchiveTags,
            model.$fromDate
        )
        .combineLatest(model.$toDate)
        .sink { [weak self] _ in
            self?.filterCards()
        }
        .store(in: &cancellables)
    }
    
    private func observeSearchTextChanges() {
        $searchText
            .sink { [weak self] _ in
                self?.filterCards()
            }
            .store(in: &cancellables)
    }
    
    private func observeCardServiceChanges() {
        CardService.shared.$cards
            .sink { [weak self] _ in
                self?.filterCards()
            }
            .store(in: &cancellables)
    }
    
    private func checkTextMatch(card: Card) -> Bool {
        if searchText.isEmpty || card.stringPhraseToRemember.lowercased().contains(searchText.lowercased()) {
            return true
        } else if let translation = card.stringTranslation {
            return translation.lowercased().contains(self.searchText.lowercased())
        }
        return false
    }
    
    private func checkStatusMatches(card: Card) -> Bool {
        if model.selectedStatuses == Status.allStatuses || model.selectedStatuses.isEmpty {
            return true
        } else {
            return model.selectedStatuses.map { $0.id }.contains(card.status.id)
        }
    }
    
    private func checkSourceMatches(card: Card) -> Bool {
        if model.selectedSources.isEmpty {
            return true
        } else if let sources = card.sources?.allObjects as? [CardSource] {
            return sources.contains(where: { model.selectedSources.contains($0) })
        }
        
        return false
    }
    
    private func checkDateRangeMatches(card: Card) -> Bool {
        let fromDateComparison = Calendar.current.compare(model.fromDate, to: card.additionTime, toGranularity: .day)
        let toDateComparison = Calendar.current.compare(model.toDate, to: card.additionTime, toGranularity: .day)
        return fromDateComparison != .orderedDescending && toDateComparison != .orderedAscending
    }
    
    private func checkArchiveTagMatches(card: Card) -> Bool {
        if model.selectedArchiveTags.isEmpty {
            return true
        } else if let archiveTag = card.archiveTag {
            return model.selectedArchiveTags.contains(archiveTag)
        }
        
        return false
    }
}
