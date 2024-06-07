//
//  ListView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI
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
    
    private func observeCardServiceChanges() {
        CardService.shared.$cards
            .sink { [weak self] _ in
                self?.setupDates()
            }
            .store(in: &cancellables)
    }
    
    func setupDates() {
        let cards = CardService.shared.cards
        
        fromDate = cards.compactMap({ $0.additionTime }).min() ?? Date()
        toDate = cards.compactMap({ $0.additionTime }).max() ?? Date()
        minDate = cards.compactMap({ $0.additionTime }).min() ?? Date()
        maxDate = cards.compactMap({ $0.additionTime }).max() ?? Date()
    }
    
    private func toggleItem<T: Equatable & Identifiable>(item: T, in array: inout [T]) {
        if let index = array.firstIndex(where: { $0.id == item.id }) {
            array.remove(at: index)
        } else {
            array.append(item)
        }
    }
    
    func toggleStatusSelection(status: Status) {
        toggleItem(item: status, in: &selectedStatuses)
    }
    
    func toggleArchiveTagSelection(tag: CardArchiveTag) {
        toggleItem(item: tag, in: &selectedArchiveTags)
    }
    
//    func toggleStatusSelection(status: Status) {
//            if selectedStatuses.contains(status) {
//                selectedStatuses.removeAll { $0.id == status.id }
//            } else {
//                selectedStatuses.append(status)
//            }
//        }
//        
//        func toggleArchiveTagSelection(tag: CardArchiveTag) {
//            if selectedArchiveTags.contains(tag) {
//                selectedArchiveTags.removeAll { $0.id == tag.id }
//            } else {
//                selectedArchiveTags.append(tag)
//            }
//        }
}

final class ListViewModel: ObservableObject {
    @Published var model = FilterableListModel()
    @Published var filteredCards: [Status: [Card]] = [:]
    @Published var searchText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    var sortedStatuses: [Status] {
        return Status.allStatuses.filter { filteredCards.keys.contains($0) }
    }
    
    init() {
        filterCards()
        observeChanges()
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

struct ListView: View {
    @StateObject var viewModel = ListViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.sortedStatuses, id: \.id) { status in
                    if let cards = viewModel.filteredCards[status] {
                        Section(header: Text(status.title)) {
                            ForEach(cards, id: \.id) { card in
                                ListRow(card: card)
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.element)
                                    .background(
                                        NavigationLink(
                                            "",
                                            destination: CardView(
                                                model: CardModel(
                                                    card: card,
                                                    mode: .view
                                                )
                                            )
                                            .toolbarTitleDisplayMode(.inline)
                                            .toolbar(.hidden, for: .tabBar)
                                        )
                                        .opacity(0)
                                    )
                            }
                            .onDelete { viewModel.delete(at: $0, from: status) }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .background(Color.element)
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer)
            .toolbarBackground(.element, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationTitle("Your Phrases")
                    .toolbar {
                        ToolbarItem {
                            NavigationLink(
                                destination: FilterView(viewModel: FilterViewModel(model: viewModel.model))
                                .toolbar(.hidden, for: .tabBar)) {
                                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle.fill")
                                }
                        }
                    }
        }
    }
}
