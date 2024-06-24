//
//  ItemSourceService.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 15/05/2024.
//

import Foundation
import CoreData

final class CardSourceService: ObservableObject {
    @Published var sources = [CardSource]()
    static let shared = CardSourceService()

    let dataController = DataController.shared

    private init() {
        do {
            sources = try fetchSources()
        } catch {
            print("Error fetching archiveTags \(error.localizedDescription)")
        }
    }

    private func fetchSources() throws -> [CardSource] {
        let fetchRequest: NSFetchRequest<CardSource> = CardSource.fetchRequest()

        do {
            return try dataController.container.viewContext.fetch(fetchRequest)
        } catch {
            throw DataServiceError.fetchFailed(description: "Failed to fetch sources: \(error.localizedDescription)")
        }
    }

    func saveSource(title: String, color: String) throws -> CardSource {
        let hashTagTitle = "#" + title.replacingOccurrences(of: "#", with: "")
        let source = CardSource(context: dataController.container.viewContext)
        source.title = hashTagTitle
        source.color = color
        source.id = UUID()

        do {
            try dataController.container.viewContext.save()

            sources.append(source)
            return source
        } catch {
            throw DataServiceError.saveFailed(description: "Failed to save source: \(error.localizedDescription)")
        }
    }

    func editSource(source: CardSource, title: String, color: String) throws {
        let hashTagTitle = "#" + title.replacingOccurrences(of: "#", with: "")
        source.title = hashTagTitle
        source.color = color

        do {
            try dataController.container.viewContext.save()
            
            if let index = sources.firstIndex(where: { $0.id == source.id }) { sources[index] = source }
        } catch {
            throw DataServiceError.saveFailed(description: "Failed to save changes to source: \(error.localizedDescription)")
        }
    }

    func deleteSource(source: CardSource) throws {
        let context = dataController.container.viewContext
        
        do {
            context.delete(source)
            self.sources.removeAll(where: { $0.id == source.id })
            try context.save()
        } catch {
            context.rollback()
            throw DataServiceError.saveFailed(description: "Failed to delete source: \(error.localizedDescription)")
        }
    }
}
