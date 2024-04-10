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
        guard let persistentStoreDescriptions = container.persistentStoreDescriptions.first else {
            fatalError("\(#function): Failed to retrieve a persistent store description.")
        }
        
        persistentStoreDescriptions.setOption(true as NSNumber,
                                              forKey: NSPersistentHistoryTrackingKey)
        persistentStoreDescriptions.setOption(true as NSNumber,
                                              forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.loadPersistentStores { _, _ in }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        items = fetchItems()
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
            
            switch item.status.id {
                case 0:
                    if let date = Date().firstSunday(after: item.additionTime), date <= Date() {
                        item.needMoveToThisMonth = true
                    } else if Date().isNextDay(from: item.additionTime) {
                        item.needMoveToThisWeek = true
                    }
                case 1:
                    if let date = Date().firstSunday(after: item.additionTime), date <= Date() {
                        item.needMoveToThisMonth = true
                    }
                default:
                    continue
            }
        }
        
        setReadyToRepeat()
        
        saveChanges()
    }
    
    /// - Throughout the day (several times as new phrases are added) →  inbox  + Source tag   +
    /// - In the morning (after one full night's sleep) →  this week
    /// - After a week →  this month
    /// - One month later →   archive   + #2024-2(Archive tag)
    /// - After three months
    /// - Six months later
    /// - One year later
    func setReadyToRepeat() {
        let items = fetchItems()
        
        items.forEach { item in
            // phrase should be repeated throughout the day several times
            guard let lastRepetitionDate = item.lastRepetition else { item.isReadyToRepeat = true; return }
            
            let firstSunday = Date().firstSunday(after: lastRepetitionDate)
            let isLastRepetitionDateToday = lastRepetitionDate.isDateToday()
            
            switch item.status.id {
                    // input, should be repeatet throughout the day
                case 0:
                    item.isReadyToRepeat = true
                    // this week, should be repeatet once a day
                case 1:
                    item.isReadyToRepeat = !isLastRepetitionDateToday
                    // this month, should be repeated every sunday throughout the month
                case 2:
                    if let firstSundayAfterLastRepetition = firstSunday, Date() >= firstSundayAfterLastRepetition {
                        item.isReadyToRepeat = true
                    } else {
                        item.isReadyToRepeat = false
                    }
                    // archive, should be repeated one month later, three months later, Six months later, one year later
                case 3:
                    if let lastTimeStatusChanged = item.lastTimeStatusChanged {
                        if Date().daysAgo(from: lastTimeStatusChanged) >= 30,
                           Date().daysAgo(from: lastRepetitionDate) >= 30 {
                            item.isReadyToRepeat = true
                        } else if Date().daysAgo(from: lastTimeStatusChanged) >= 90,
                                  Date().daysAgo(from: lastRepetitionDate) >= 60 {
                            item.isReadyToRepeat = true
                        } else if Date().daysAgo(from: lastTimeStatusChanged) >= 180,
                                  Date().daysAgo(from: lastRepetitionDate) >= 90 {
                            item.isReadyToRepeat = true
                        } else if Date().daysAgo(from: lastTimeStatusChanged) >= 360,
                                  Date().daysAgo(from: lastRepetitionDate) >= 180 {
                            item.isReadyToRepeat = true
                        }
                    } else {
                        item.isReadyToRepeat = false
                    }
                default:
                    break
            }
        }
        
        saveChanges()
    }
    
    func checkReadyToRepeat(items: [Item]) -> [Item] {
        items.forEach { item in
            // phrase should be repeated throughout the day several times
            guard let lastRepetitionDate = item.lastRepetition else { item.isReadyToRepeat = true; return }
            
            let firstSunday = Date().firstSunday(after: lastRepetitionDate)
            let isLastRepetitionDateToday = lastRepetitionDate.isDateToday()
            
            switch item.status.id {
                    // input, should be repeatet throughout the day
                case 0:
                    item.isReadyToRepeat = true
                    // this week, should be repeatet once a day
                case 1:
                    item.isReadyToRepeat = !isLastRepetitionDateToday
                    // this month, should be repeated every sunday throughout the month
                case 2:
                    if let firstSundayAfterLastRepetition = firstSunday, Date() >= firstSundayAfterLastRepetition {
                        item.isReadyToRepeat = true
                    } else {
                        item.isReadyToRepeat = false
                    }
                    // archive, should be repeated one month later, three months later, Six months later, one year later
                case 3:
                    if let lastTimeStatusChanged = item.lastTimeStatusChanged {
                        if Date().daysAgo(from: lastTimeStatusChanged) >= 30,
                           Date().daysAgo(from: lastRepetitionDate) >= 30 {
                            item.isReadyToRepeat = true
                        } else if Date().daysAgo(from: lastTimeStatusChanged) >= 90,
                                  Date().daysAgo(from: lastRepetitionDate) >= 60 {
                            item.isReadyToRepeat = true
                        } else if Date().daysAgo(from: lastTimeStatusChanged) >= 180,
                                  Date().daysAgo(from: lastRepetitionDate) >= 90 {
                            item.isReadyToRepeat = true
                        } else if Date().daysAgo(from: lastTimeStatusChanged) >= 360,
                                  Date().daysAgo(from: lastRepetitionDate) >= 180 {
                            item.isReadyToRepeat = true
                        }
                    } else {
                        item.isReadyToRepeat = false
                    }
                default:
                    break
            }
        }
        return items
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
        item.transcription = transcription
        item.status = Status.input
        item.image = image?.pngData()
        item.sources = NSSet(set: sources)
        item.id = UUID()
#warning("remove")
        // item.additionTime = Date()
        item.additionTime = Date().subtractingDays(60) ?? Date()
        
        item.archiveTag = (Date().subtractingDays(60) ?? Date()).prepareTag()
        
        //        item.archiveTag = Date().prepareTag()
#warning("remove")
        item.needMoveToThisWeek = true
        
        saveChanges()
    }
    
    func deleteItem(_ item: Item) {
        
        container.viewContext.delete(item)
        
        saveChanges()
    }
    
    private func saveChanges() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        items = fetchItems()
    }
    
    func getHint() -> String {
        let items = fetchItems()
        
        let readyToRepeatItems = checkReadyToRepeat(items: items)
        
        if readyToRepeatItems.isEmpty {
            return "Add your first card"
        } else if readyToRepeatItems.filter({ $0.isReadyToRepeat }).isEmpty {
            return "That's it for today, but you can add new cards"
        }
        
        return ""
    }
    
    func containsCardsToRepeat() -> Bool {
        let items = fetchItems()
        
        if items.isEmpty { return false }
        
        let readyToRepeatItems = checkReadyToRepeat(items: items)
        
        return !readyToRepeatItems.filter({ $0.isReadyToRepeat }).isEmpty
    }
    
    func getArchiveTags() -> [String] {
        let items = fetchItems()
        
        return Array(Set(items.map { $0.archiveTag }))
    }
    
    func getMinMaxDate() -> (min: Date, max: Date) {
        let items = fetchItems()
        
        let minDate = items.map({ $0.additionTime }).min() ?? Date()
        let maxDate = items.map({ $0.additionTime }).max() ?? Date()
        
        return (minDate, maxDate)
    }
}
