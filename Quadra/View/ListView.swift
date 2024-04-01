//
//  ListView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var dataManager: CardManager
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) var sources: FetchedResults<Source>
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>
    @State private var previousItems: [Item] = []
    @State var selectedStatuses: [Status] = []
    @State var fromDate: Date = Date()
    @State var toDate: Date = Date()
    @State var selectedSources: [Source] = []
    @State var selectedArchiveTags: [String] = []
    @State var filteredItems: [Item] = []
    @State private var isFromDateInitialized = false
    @State var minDate = Date()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                listViewContent(geometry: geometry)
                    .onAppear {
                        performChecks()
                        updateFilteredItems()
                    }
            }
        }
    }
    
    private func listViewContent(geometry: GeometryProxy) -> some View {
        List {
            ForEach(filteredItems) { item in
                ListRow(item: item)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.element)
                    .background(
                        NavigationLink("", destination: CardView(item: item,
                                                                 geometry: geometry,
                                                                 presentationMode: .view)
                            .toolbar(.hidden, for: .tabBar)
                            .padding(geometry.size.width/12)
                            .background(Color.element))
                        .opacity(0)
                    )
            }.onDelete(perform: delete)
        }
        .listStyle(.plain)
        .background(Color.element)
        .toolbar {
            ToolbarItem {
                NavigationLink(destination:
                                FilterView(selectedStatuses: $selectedStatuses,
                                           selectedArchiveTags: $selectedArchiveTags, 
                                           fromDate: $fromDate,
                                           toDate: $toDate,
                                           selectedSources: $selectedSources,
                                           minDate: $minDate,
                                           archiveTags: dataManager.getArchiveTags())
                                    .environmentObject(dataManager)
                                    .environment(\.managedObjectContext, dataManager.container.viewContext)
                                    .toolbar(.hidden, for: .tabBar)) {
                                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle.fill")
                                    }
            }
        }
    }
    
    func performChecks() {
        if !isFromDateInitialized { setDate() }
    }
    
    func setDate() {
        let (minDate, maxDate) = dataManager.getMinMaxDate()
    
        fromDate = minDate
        self.minDate = minDate
        toDate = maxDate
        isFromDateInitialized = true
    }
    
    func updateFilteredItems() {
        filteredItems = Array(items)
            .filter { item in
                let statusMatches: Bool
                if selectedStatuses == Status.allStatuses || selectedStatuses.isEmpty {
                    statusMatches = true
                } else {
                    statusMatches = selectedStatuses.map { $0.id }.contains(item.status.id)
                }

                var sourceMatches: Bool = false
                if selectedSources.isEmpty {
                    sourceMatches = true
                } else {
                    if let sources = item.sources?.allObjects as? [Source] {
                        sourceMatches = sources.contains(where: { selectedSources.contains($0) })
                    }
                }
                
                let fromDateComparison = Calendar.current.compare(fromDate, to: item.additionTime, toGranularity: .day)
                let toDateComparison = Calendar.current.compare(toDate, to: item.additionTime, toGranularity: .day)
                
                let dateRangeMatches = fromDateComparison != .orderedDescending && toDateComparison != .orderedAscending
                
                let archiveTagMatches: Bool
                
                if selectedArchiveTags.isEmpty {
                    archiveTagMatches = true
                } else {
                    archiveTagMatches = selectedArchiveTags.contains(item.archiveTag)
                }
                
                return statusMatches && sourceMatches && dateRangeMatches && archiveTagMatches
            }
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            dataManager.deleteItem(filteredItems[index])
        }
        updateFilteredItems()
    }
}

//#Preview {
//    return ListView()
//        .environmentObject(DataManager())
//}
