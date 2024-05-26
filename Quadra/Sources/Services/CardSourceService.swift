//
//  ItemSourceService.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 15/05/2024.
//

import Foundation
import CoreData
import SwiftUI

final class CardSourceService {
    static let shared = CardSourceService()
    
    let dataController = DataController.shared
    
    private init() { }
    
    func fetchSources() throws -> [CardSource] {
        let fetchRequest: NSFetchRequest<CardSource> = CardSource.fetchRequest()
        
        do {
            return try dataController.container.viewContext.fetch(fetchRequest)
        } catch {
            throw DataServiceError.fetchFailed(description: "Failed to fetch sources: \(error.localizedDescription)")
        }
    }
    
    func saveSource(title: String, color: String) throws -> CardSource {
        let source = CardSource(context: dataController.container.viewContext)
        source.title = title
        source.color = color
        source.id = UUID()
        
        do {
            try dataController.container.viewContext.save()
            return source
        } catch {
            throw DataServiceError.saveFailed(description: "Failed to save source: \(error.localizedDescription)")
        }
    }
    
    func editSource(source: CardSource, title: String, color: String) throws {
        source.title = title
        source.color = color
        
        do {
            try dataController.container.viewContext.save()
        } catch {
            throw DataServiceError.saveFailed(description: "Failed to save changes to source: \(error.localizedDescription)")
        }
    }
    
    func deleteSource(source: CardSource) throws {
        dataController.container.viewContext.delete(source)
        
        do {
            try dataController.container.viewContext.save()
        } catch {
            throw DataServiceError.saveFailed(description: "Failed to delete source: \(error.localizedDescription)")
        }
    }
}
