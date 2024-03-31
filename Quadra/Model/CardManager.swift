//
//  DataManager.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import UIKit
import CoreData

class CardManager: NSObject, ObservableObject {
    @Published var items: [Item] = [Item]()
    
    let container: NSPersistentContainer = NSPersistentContainer(name: "Quadra")
    
    override init() {
        super.init()
        ValueTransformer.setValueTransformer(StatusTransformer(), forName: NSValueTransformerName("StatusTransformer"))
        container.loadPersistentStores { _, _ in }
    }
    
    func fetchItems() -> [Item] {
        do {
            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching items: \(error)")
            return []
        }
    }
    
    public func setNewStatus(for item: Item) {
        if item.needMoveToThisWeek {
            item.status = .thisWeek
            item.needMoveToThisWeek = false
        } else if item.needMoveToThisMonth {
            item.status = .thisMonth
            item.needMoveToThisMonth = false
        } else if item.needMoveToArchive {
            item.status = .archive
            item.isArchived = true
            item.needMoveToArchive = false
        }
        
        item.lastTimeStatusChanged = Date()
        saveChanges()
    }
    
    public func performCheсks() {
        let items = fetchItems()
        
        for item in items {
            if let date = item.lastTimeStatusChanged, date.isDateToday() || item.isArchived { continue }
            
            if let date = Date().lastSundayOfMonth(for: item.additionTime), date <= Date() {
                item.needMoveToArchive = true
                continue
            }
            
            switch item.status.title {
                case Status.input.title:
                    if let date = Date().firstSunday(after: item.additionTime), date <= Date() {
                        item.needMoveToThisMonth = true
                    } else if Date().isNextDay(from: item.additionTime) {
                        item.needMoveToThisWeek = true
                    }
                case Status.thisWeek.title:
                    if let date = Date().firstSunday(after: item.additionTime), date <= Date() {
                        item.needMoveToThisMonth = true
                    }
                default:
                    continue
            }
        }

        saveChanges()
    }
    
    func incrementCounter(for item: Item) {
        item.repetitionCounter += 1
        item.lastRepetition = Date()
        
        saveChanges()
    }
    
    func createItem(phraseToRemember: String,
                    translation: String?,
                    transcription: String?,
                    sources: Set<Source>,
                    image: UIImage?) {
        
        let item = Item(context: self.container.viewContext)
        
        item.phraseToRemember = phraseToRemember
        item.translation = translation
        item.status = Status.input
        item.image = image?.pngData()
        item.sources = NSSet(set: sources)
        item.id = UUID()
#warning("change")
        //item.additionTime = Date()
        item.additionTime = Date().subtractingDays(60) ?? Date()

        item.archiveTag = Date().prepareTag()
        #warning("change")
        item.needMoveToThisWeek = true
        
        saveChanges()
    }
    
    func deleteItem(_ item: Item) {
        container.viewContext.delete(item)

        do {
            try container.viewContext.save()
        } catch {
            print("Error deleting item: \(error)")
        }
        
        saveChanges()
    }
    
    private func saveChanges() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
