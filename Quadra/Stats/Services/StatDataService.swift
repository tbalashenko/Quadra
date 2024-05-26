//
//  StatDataService.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/05/2024.
//

import Foundation
import CoreData

class StatDataService: ObservableObject {
    @Published var statData = [StatData]()
    static let shared = StatDataService()
    let dataController = DataController.shared
    
    private init() {
        fetchStatData()
    }
    
    func fetchStatData() {
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        do {
            statData = try fetchStatData(sortDescriptors: [sortDescriptor])
        } catch {
            print("Error fetching statData \(error.localizedDescription)")
        }
    }
    
    func fetchStatData(sortDescriptors: [NSSortDescriptor], predicate: NSPredicate? = nil) throws -> [StatData] {
        let fetchRequest: NSFetchRequest<StatData> = StatData.fetchRequest()
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        do {
            return try dataController.container.viewContext.fetch(fetchRequest)
        } catch {
            throw DataServiceError.fetchFailed(description: "Failed to fetch StatData: \(error.localizedDescription)")
        }
    }
    
    func saveStatData(
        date: Date = Date(),
        repeatedItemsCounter: Int = 0,
        addedItemsCounter: Int = 0,
        deletedItemsCounter: Int = 0,
        totalNumberOfCards: Int) throws {
            let statData = StatData(context: DataController.shared.container.viewContext)
            statData.repeatedItemsCounter = repeatedItemsCounter
            statData.addedItemsCounter = addedItemsCounter
            statData.deletedItemsCounter = deletedItemsCounter
            statData.totalNumberOfCards = totalNumberOfCards
            statData.date = date
            
            do {
                try dataController.container.viewContext.save()
            } catch {
                throw DataServiceError.saveFailed(description: "Failed to save StatData: \(error.localizedDescription)")
            }
            
            fetchStatData()
        }
    
    func editStatData(
        statData: StatData,
        repeatedItemsCounter: Int? = nil,
        addedItemsCounter: Int? = nil,
        deletedItemsCounter: Int? = nil,
        totalNumberOfCards: Int? = nil) throws {
            if let repeatedItemsCounter = repeatedItemsCounter {
                statData.repeatedItemsCounter = repeatedItemsCounter
            }
            if let addedItemsCounter = addedItemsCounter {
                statData.addedItemsCounter = addedItemsCounter
            }
            if let deletedItemsCounter = deletedItemsCounter {
                statData.deletedItemsCounter = deletedItemsCounter
            }
            if let totalNumberOfCards = totalNumberOfCards {
                statData.totalNumberOfCards = totalNumberOfCards
            }
            
            do {
                try dataController.container.viewContext.save()
            } catch {
                throw DataServiceError.saveFailed(description: "Failed to save changes to StatData: \(error.localizedDescription)")
            }
            
            fetchStatData()
        }
    
    func incrementRepeatedItemsCounter() {
        let currentDate = Date().formattedForStats()
        if let statData = statData.first(where: { $0.date == currentDate }) {
            do {
                try editStatData(statData: statData, repeatedItemsCounter: statData.repeatedItemsCounter + 1)
            } catch {
                print("Failed to save changes to StatData: \(error.localizedDescription)")
            }
        } else {
            do {
                try saveStatData(
                    date: currentDate ?? Date(),
                    repeatedItemsCounter: 1,
                    totalNumberOfCards: CardService.shared.cards.count)
            } catch {
                print("Error creating statData: \(error.localizedDescription)")
            }
        }
    }
    
    func incrementAddedItemsCounter() {
        let currentDate = Date().formattedForStats()
        if let statData = statData.first(where: { $0.date == currentDate }) {
            do {
                try editStatData(
                    statData: statData,
                    addedItemsCounter: statData.addedItemsCounter + 1,
                    totalNumberOfCards: CardService.shared.cards.count)
            } catch {
                print("Failed to save changes to StatData: \(error.localizedDescription)")
            }
        } else {
            do {
                try saveStatData(
                    date: currentDate ?? Date(),
                    repeatedItemsCounter: 1,
                    totalNumberOfCards: CardService.shared.cards.count)
            } catch {
                print("Error creating statData: \(error.localizedDescription)")
            }
        }
    }
}

enum DataServiceError: Error {
    case fetchFailed(description: String)
    case saveFailed(description: String)
}

