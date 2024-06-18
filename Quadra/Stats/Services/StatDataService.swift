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
        deletedItemsCounter: Int = 0) throws -> StatData? {
            let statData = StatData(context: DataController.shared.container.viewContext)
            statData.repeatedItemsCounter = repeatedItemsCounter
            statData.addedItemsCounter = addedItemsCounter
            statData.deletedItemsCounter = deletedItemsCounter
            statData.totalNumberOfCards = CardService.shared.cards.count
            statData.date = date
            
            do {
                try dataController.container.viewContext.save()
                self.statData.append(statData)
                return statData
            } catch {
                throw DataServiceError.saveFailed(description: "Failed to save StatData: \(error.localizedDescription)")
            }
        }
    
    func editStatData(
        statData: StatData,
        repeatedItemsCounter: Int? = nil,
        addedItemsCounter: Int? = nil,
        deletedItemsCounter: Int? = nil) throws {
            if let repeatedItemsCounter {
                statData.repeatedItemsCounter = repeatedItemsCounter
            }
            if let addedItemsCounter {
                statData.addedItemsCounter = addedItemsCounter
            }
            if let deletedItemsCounter {
                statData.deletedItemsCounter = deletedItemsCounter
            }
            
            statData.totalNumberOfCards = CardService.shared.cards.count
            
            do {
                try dataController.container.viewContext.save()
                
                guard let statDataToChangeIndex = self.statData.firstIndex(where: { $0.date == statData.date }) else { return }
                
                self.statData[statDataToChangeIndex] = statData
            } catch {
                throw DataServiceError.saveFailed(description: "Failed to save changes to StatData: \(error.localizedDescription)")
            }
        }
    
    func incrementRepeatedItemsCounter() {
        guard let statData = getStatData() else { return }
        
        do {
            try editStatData(
                statData: statData,
                repeatedItemsCounter: statData.repeatedItemsCounter + 1
            )
        } catch {
            print("Failed to save changes to StatData: \(error.localizedDescription)")
        }
    }
    
    func incrementAddedItemsCounter() {
        guard let statData = getStatData() else { return }
        
        do {
            try editStatData(
                statData: statData,
                addedItemsCounter: statData.addedItemsCounter + 1
            )
        } catch {
            print("Failed to save changes to StatData: \(error.localizedDescription)")
        }
    }
    
    func incrementDeletedItemsCounter() {
        guard let statData = getStatData() else { return }
        
        do {
            try editStatData(
                statData: statData,
                deletedItemsCounter: statData.deletedItemsCounter + 1
            )
        } catch {
            print("Failed to save changes to StatData: \(error.localizedDescription)")
        }
    }
    
    func getStatData() -> StatData? {
        let currentDate = Date().formattedForStats()
        
        if let statData = statData.first(where: { $0.date == currentDate }) {
            return statData
        } else {
            do {
                return try saveStatData(date: currentDate ?? Date())
            } catch {
                print("Error creating statData: \(error.localizedDescription)")
            }
        }
        
        return nil
    }
}

enum DataServiceError: Error {
    case fetchFailed(description: String)
    case saveFailed(description: String)
}

