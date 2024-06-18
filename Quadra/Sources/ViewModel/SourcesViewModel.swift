//
//  SourcesViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 15/05/2024.
//

import Foundation

final class SourcesViewModel: ObservableObject {
    @Published var sources = [CardSource]()

    let service = CardSourceService.shared

    init() {
        self.sources = service.sources
    }

    func delete(source: CardSource) {
        do {
            try service.deleteSource(source: source)
            self.sources = service.sources
        } catch {
            print("Failed to delete source: \(error.localizedDescription)")
        }
    }
}
