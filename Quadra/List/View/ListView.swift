//
//  ListView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI

struct ListView: View {
    @StateObject var viewModel = ListViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.sortedStatuses, id: \.id) { status in
                    if let cards = viewModel.filteredCards[status] {
                        Section(header: Text(status.title)) {
                            ForEach(cards, id: \.id) { card in
                                ListRowView(card: card)
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
            .if(viewModel.isSearchPresented) {
                $0.searchable(
                    text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .automatic)
                )
            }
            .toolbarBackground(.element, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationTitle(TextConstants.yourPhrases)
            .toolbar {
                ToolbarItem {
                    NavigationLink(
                        destination: FilterView(viewModel: FilterViewModel(model: viewModel.model))
                            .toolbar(.hidden, for: .tabBar)) {
                                Label(TextConstants.filter, systemImage: "line.3.horizontal.decrease.circle.fill")
                            }
                }
            }
        }
    }
}
