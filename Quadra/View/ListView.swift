//
//  ListView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

//import SwiftUI
//
//final class ListViewModel: ObservableObject {
//    @Published var sources = [CardSource]()
//    @Published var items = [Card]()
//    @Published var archiveTags = [CardArchiveTag]()
//    @Published var statData = [StatData]()
//    @Published var selectedSources = [CardSource]()
//    @Published var selectedStatuses = [Status]()
//    @Published var selectedArchiveTags = [CardArchiveTag]()
//    @Published var filteredItems = [Card]()
//    
//}
//
//struct ListView: View {
//    @StateObject var viewModel = ListViewModel()
//    
//    @State var fromDate: Date = Date()
//    @State var toDate: Date = Date()
//    @State private var isDateSetFromFilter = false
//    @State var minDate = Date()
//    @State private var isSearching = false
//    @State var searchText = ""
//    @State var isLoading = true
//    let settingsManager = SettingsManager.shared
//    
//    var body: some View {
//        GeometryReader { geometry in
//            NavigationStack {
//                listViewContent(geometry: geometry)
//                    .onAppear {
//                        setDate()
//                        updateFilteredItems()
//                    }
//                    .onChange(of: searchText) { _, _ in
//                        updateFilteredItems()
//                    }
//                    .onDisappear {
//                        filteredItems = []
//                    }
//                    .searchable(text: $searchText, placement: .navigationBarDrawer)
//            }
//        }
//    }
//    
//    @ViewBuilder
//    private func listViewContent(geometry: GeometryProxy) -> some View {
//        let groupedItems = Dictionary(grouping: filteredItems, by: { $0.status.title })
//        
//        List {
//            ForEach(Array(groupedItems), id: \.key) { section in
//                let (status, items) = section
//                Section(header: Text(status)) {
//                    ForEach(items, id: \.id) { item in
//                        listRowContent(item: item, geometry: geometry)
//                    }
//                    .onDelete(perform: delete)
//                }
//            }
//        }
//        .listStyle(.plain)
//        .background(Color.element)
//        .navigationTitle("Your Phrases")
//        .toolbarBackground(.element, for: .navigationBar)
//        .toolbarBackground(.visible, for: .navigationBar)
//        .toolbar {
//            ToolbarItem {
//                NavigationLink(
//                    destination: FilterView(
//                        selectedStatuses: $selectedStatuses,
//                        selectedArchiveTags: $selectedArchiveTags,
//                        fromDate: $fromDate, 
//                        toDate: $toDate,
//                        isDateSetFromFilter: $isDateSetFromFilter,
//                        selectedSources: $selectedSources,
//                        minDate: $minDate,
//                        archiveTags: Array(archiveTags))
//                    .environmentObject(dataController)
//                    .environment(\.managedObjectContext, viewContext)
//                    .toolbar(.hidden, for: .tabBar)) {
//                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle.fill")
//                    }
//            }
//        }
//    }
//    
//    @ViewBuilder
//    private func listRowContent(card: Card, geometry: GeometryProxy) -> some View {
//        ListRow(viewModel: ListRowViewModel(card: Card))
//            .listRowSeparator(.hidden)
//            .listRowBackground(Color.element)
//            .background(
//                NavigationLink("", destination: CardView(item: item, cardViewPresentationMode: .view)
//                    .toolbarTitleDisplayMode(.inline)
//                    .toolbar(.hidden, for: .tabBar)
//                    .padding(geometry.size.width/12)
//                    .background(Color.element))
//                .opacity(0)
//            )
//    }
//    
//    private func setDate() {
//        if !isDateSetFromFilter {
//            let minDate = items.map({ $0.additionTime }).min() ?? Date()
//            let maxDate = items.map({ $0.additionTime }).max() ?? Date()
//            
//            fromDate = minDate
//            self.minDate = minDate
//            toDate = maxDate
//        }
//    }
//    
//    private func updateFilteredItems() {
//        filteredItems = items
//            .filter { item in
//                !item.isFault && !item.isDeleted
//            }
//            .filter { item in
//                var textMatch: Bool = false
//                if searchText.isEmpty {
//                    textMatch = true
//                } else if item.phraseToRemember.string.lowercased().contains(searchText.lowercased()) {
//                    textMatch = true
//                } else if let translation = item.translation {
//                    return translation.string.lowercased().contains(searchText.lowercased())
//                }
//                
//                let statusMatches: Bool
//                if selectedStatuses == Status.allStatuses || selectedStatuses.isEmpty {
//                    statusMatches = true
//                } else {
//                    statusMatches = selectedStatuses.map { $0.id }.contains(item.status.id)
//                }
//                
//                var sourceMatches: Bool = false
//                if selectedSources.isEmpty {
//                    sourceMatches = true
//                } else {
//                    if let sources = item.sources?.allObjects as? [ItemSource] {
//                        sourceMatches = sources.contains(where: { selectedSources.contains($0) })
//                    }
//                }
//                
//                var dateRangeMatches = true
//                
//                if isDateSetFromFilter {
//                    let fromDateComparison = Calendar.current.compare(fromDate, to: item.additionTime, toGranularity: .day)
//                    let toDateComparison = Calendar.current.compare(toDate, to: item.additionTime, toGranularity: .day)
//                    dateRangeMatches = fromDateComparison != .orderedDescending && toDateComparison != .orderedAscending
//                }
//                
//                let archiveTagMatches: Bool
//                
//                if selectedArchiveTags.isEmpty {
//                    archiveTagMatches = true
//                } else {
//                    archiveTagMatches = selectedArchiveTags.contains(item.archiveTag)
//                }
//                
//                return textMatch && statusMatches && sourceMatches && dateRangeMatches && archiveTagMatches
//            }
//    }
//    
//    private func delete(at offsets: IndexSet) {
//        for index in offsets {
//            viewContext.delete(filteredItems[index])
//            filteredItems.remove(at: index)
//            saveStatData()
//            try? viewContext.save()
//        }
//    }
//    
//    func saveStatData() {
//        let currentDate = Date().formattedForStats()
//        
//        if let statData = statData.first(where: { $0.date == currentDate }) {
//            statData.totalNumberOfCards = items.count
//            statData.deletedItemsCounter += 1
//        } else {
//            let statData = StatData(context: viewContext)
//            statData.date = currentDate ?? Date()
//            statData.totalNumberOfCards = items.count
//            statData.deletedItemsCounter += 1
//        }
//    }
//}
//
//// #Preview {
////    return ListView()
////        .environmentObject(DataManager())
//// }
