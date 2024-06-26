//
//  ListView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI
import Combine

struct ListView: View {
    @ObservedObject var viewModel = ListViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(CardStatus.allCases, id: \.id) { status in
                    if let cards = viewModel.filteredCards[status], !cards.isEmpty {
                        Section(header: Text(status.title)) {
                            ForEach(cards, id: \.id) { card in
                                ListRowView()
                                    .customListRow()
                                    .environmentObject(CardModel(card: card, mode: .view))
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    viewModel.delete(card: cards[index])
                                }
                            }
                        }
                    }
                }
            }
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .automatic)
            )
            .customListStyle()
            .navigationTitle(TextConstants.yourPhrases)
            .toolbar(.visible, for: .tabBar)
            .toolbar {
                ToolbarItem {
                    NavigationLink(
                        destination: FilterView()
                            .toolbar(.hidden, for: .tabBar)
                    ) {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                            .smallButtonImage()
                            .foregroundStyle(Color.accentColor)
                    }
                    .buttonStyle(NeuButtonStyle())
                }
            }
        }
    }
}
