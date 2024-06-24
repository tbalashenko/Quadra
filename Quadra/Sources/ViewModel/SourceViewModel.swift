//
//  SourceViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 15/05/2024.
//

import Foundation

final class SourceViewModel: ObservableObject {
    var source: CardSource
    @Published var editableTitle: String = ""
    @Published var compoundTitle: String = ""
    @Published var color: String = ""
    private var titleCopy: String = ""

    let sourceService = CardSourceService.shared

    init(source: CardSource) {
        self.source = source
        self.editableTitle = source.title
        self.titleCopy = source.title
        self.compoundTitle = getTitle(for: source)
        self.color = source.color
    }

    func saveChanges() {
        do {
            try sourceService.editSource(source: source, title: editableTitle, color: color)
            titleCopy = source.title
        } catch {
            print("Failed to save source: \(error.localizedDescription)")
        }
        compoundTitle = getTitle(for: source)
    }
    
    func resetChanges() {
        editableTitle = titleCopy
    }
    
    /// Generates a title for the source based on the count of cards.
    /// - Parameter source: The card source.
    /// - Returns: The formatted title string.
    private func getTitle(for source: CardSource) -> String {
        guard let cardsCount = source.cards?.count else {
            return source.title
        }

        switch cardsCount {
            case 0:
                return "\(source.title) - \(TextConstants.noCards)"
            case 1:
                return "\(source.title) - \(TextConstants.oneCard)"
            default:
                return "\(source.title) - \(cardsCount) \(TextConstants.cards)"
        }
    }
}
