//
//  ArhiveTagService.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/05/2024.
//

import Foundation
import CoreData

class ArchiveTagService: ObservableObject {
    @Published var archiveTags = [CardArchiveTag]()
    static let shared = ArchiveTagService()
    
    let dataController = DataController.shared
    
    private init() {
        do {
            archiveTags = try fetchArchiveTags()
        } catch {
            print("Error fetching archiveTags \(error.localizedDescription)")
        }
    }
    
    func fetchArchiveTags() throws -> [CardArchiveTag] {
        let fetchRequest: NSFetchRequest<CardArchiveTag> = CardArchiveTag.fetchRequest()
        
        do {
            return try dataController.container.viewContext.fetch(fetchRequest)
        } catch {
            throw DataServiceError.fetchFailed(description: "Failed to fetch archive tags: \(error.localizedDescription)")
        }
    }
    
    func saveArchiveTag(date: Date = Date()) throws -> CardArchiveTag {
        let tag = CardArchiveTag(context: dataController.container.viewContext)
        tag.id = UUID()
        tag.color = CardArchiveTag.getColor(for: date)
        tag.title = date.prepareTag()
        
        do {
            try dataController.container.viewContext.save()
            
            archiveTags.append(tag)
            
            return tag
        } catch {
            throw DataServiceError.saveFailed(description: "Failed to save archive tag: \(error.localizedDescription)")
        }
    }
    
    func getArchiveTag(date: Date = Date()) throws -> CardArchiveTag? {
        do {
            if let tag = archiveTags.first(where: { $0.title == date.prepareTag() }) {
                return tag
            }
            
            return try ArchiveTagService.shared.saveArchiveTag(date: date)
        } catch {
            print("Error fetching or saving archive tag: \(error.localizedDescription)")
            return nil
        }
    }
}

