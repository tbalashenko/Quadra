//
//  ListViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 08/06/2024.
//

import Foundation
import Combine

final class ListViewModel: ObservableObject {
    @Published var filteredCards: [CardStatus: [Card]] = [:]
    @Published var searchText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let service = FilterService.shared
    
    init() {
        observeCardServiceChanges()
        observeSearchTextChanges()
        observeFilterServiceChanges()
    }
    
    private func observeCardServiceChanges() {
        CardService.shared.$cards
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
    
    private func observeFilterServiceChanges() {
        Publishers.CombineLatest4(
            service.$selectedStatuses,
            service.$selectedSources,
            service.$selectedArchiveTags,
            service.$fromDate
        )
        .combineLatest(service.$toDate)
        .sink { [weak self] _ in
            self?.filterCards()
        }
        .store(in: &cancellables)
    }
    
    private func filterCards() {
        Task {
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                
                let filteredCards = CardService.shared.cards
                    .filter { !$0.isFault || !$0.isDeleted}
                    .filter { card in
                        let textMatch = self.checkTextMatch(card: card)
                        let statusMatches = self.checkStatusMatches(card: card)
                        let sourceMatches = self.checkSourceMatches(card: card)
                        let dateRangeMatches = self.checkDateRangeMatches(card: card)
                        let archiveTagMatches = self.checkArchiveTagMatches(card: card)
                        
                        return textMatch && statusMatches && sourceMatches && dateRangeMatches && archiveTagMatches
                    }
                self.filteredCards = Dictionary(grouping: filteredCards, by: { CardStatus(rawValue: $0.cardStatus) ?? .input })
            }
        }
    }
    
    func delete(card: Card) {
        do {
            try CardService.shared.delete(card: card)
        } catch {
            print("Error deleting card \(error.localizedDescription)")
        }
    }
}

extension ListViewModel {
    private func checkTextMatch(card: Card) -> Bool {
        if searchText.isEmpty || card.stringPhraseToRemember.lowercased().contains(searchText.lowercased()) {
            return true
        } else if let translation = card.stringTranslation {
            return translation.lowercased().contains(self.searchText.lowercased())
        }
        return false
    }
    
    private func checkStatusMatches(card: Card) -> Bool {
        if FilterService.shared.selectedStatuses == CardStatus.allCases || FilterService.shared.selectedStatuses.isEmpty {
            return true
        } else {
            return FilterService.shared.selectedStatuses.map { $0.id }.contains(card.cardStatus)
        }
    }
    
    private func checkSourceMatches(card: Card) -> Bool {
        if FilterService.shared.selectedSources.isEmpty {
            return true
        } else if let sources = card.sources?.allObjects as? [CardSource] {
            return sources.contains(where: { FilterService.shared.selectedSources.contains($0) })
        }
        
        return false
    }
    
    private func checkDateRangeMatches(card: Card) -> Bool {
        let fromDateComparison = Calendar.current.compare(FilterService.shared.fromDate, to: card.additionTime, toGranularity: .day)
        let toDateComparison = Calendar.current.compare(FilterService.shared.toDate, to: card.additionTime, toGranularity: .day)
        return fromDateComparison != .orderedDescending && toDateComparison != .orderedAscending
    }
    
    private func checkArchiveTagMatches(card: Card) -> Bool {
        if FilterService.shared.selectedArchiveTags.isEmpty {
            return true
        } else if let archiveTag = card.archiveTag {
            return FilterService.shared.selectedArchiveTags.contains(archiveTag)
        }
        
        return false
    }
}
