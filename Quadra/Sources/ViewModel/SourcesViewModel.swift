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
        fetchSources()
    }
    
    func fetchSources() {
        do {
            sources = try service.fetchSources()
        } catch {
            print("Failed to fetch sources: \(error.localizedDescription)")
        }
    }
    
    func delete(source: CardSource) {
        do {
            try service.deleteSource(source: source)
            fetchSources()
        } catch {
            print("Failed to delete source: \(error.localizedDescription)")
        }
    }
}
