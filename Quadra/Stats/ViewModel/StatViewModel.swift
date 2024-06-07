//
//  StatViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/05/2024.
//

import Foundation

class StatViewModel: ObservableObject {
    @Published var statData = [StatData]()
    @Published var showTotalNumber = false
    @Published var showAddedCards = true
    @Published var showRepeatedCards = true
    @Published var showDeletedCards = true
    
    init() {
        fetchStatData()
    }
    
    func fetchStatData(fromDate: Date? = nil) {
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        var predicate: NSPredicate? = nil
        if let fromDate = fromDate {
            predicate = NSPredicate(format: "date >= %@ AND date <= %@", fromDate as NSDate, Date() as NSDate)
        }
        
        guard let data = try? StatDataService.shared.fetchStatData(sortDescriptors: [sortDescriptor], predicate: predicate) else { return }
        
        statData = data
    }
    
    func getStatDataState() -> StatDataState {
        return StatDataService.shared.statData.isEmpty ? .empty : .notEnoughData
    }
    
#if DEBUG
    func addRandomData() {
        let fromDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
        
        for index in stride(from: 0, to: 366, by: 2) {
            let date = Calendar.current.date(byAdding: .day, value: index, to: fromDate) ?? Date()
            let string = "Test" + String("\(date)")
            let phraseToRemember = AttributedString(stringLiteral: string)
            
            do {
                try CardService.shared.saveCard(
                    phraseToRemember: phraseToRemember,
                    additionDate: date,
                    incrementAddedItemsCounter: false
                )
            } catch {
                print("Error saving item: \(error.localizedDescription)")
            }
            
            let currentDate = date.formattedForStats()
            
            if let statData = statData.first(where: { $0.date == currentDate }) {
                do {
                    try StatDataService.shared.editStatData(
                        statData: statData,
                        repeatedItemsCounter: Int.random(in: 1...5),
                        addedItemsCounter: Int.random(in: 1...3),
                        deletedItemsCounter: Int.random(in: 0...1))
                } catch {
                    print("Error editing stat data: \(error.localizedDescription)")
                }
            } else {
                do {
                    try StatDataService.shared.saveStatData(
                        date: currentDate ?? Date(),
                        repeatedItemsCounter: Int.random(in: 1...5),
                        addedItemsCounter: Int.random(in: 1...3),
                        deletedItemsCounter: Int.random(in: 0...1))
                } catch {
                    print("Error saving stat data: \(error.localizedDescription)")
                }
            }
        }
        fetchStatData(fromDate: fromDate)
    }
#endif
}

extension StatViewModel {
    enum StatDataState {
        case empty
        case notEnoughData
        case noDataForPeriod
        
        var instructionFirstPart: String {
            switch self {
                case .empty:
                    return "Add your first cards"
                case .notEnoughData:
                    return "Continue adding and repeating your cards daily to see statistics"
                case .noDataForPeriod:
                    return ""
            }
        }
        
        var instructionSecondPart: String? {
            switch self {
                case .empty:
                    return "Continue adding and repeating your cards daily to see statistics"
                case .notEnoughData:
                    return nil
                case .noDataForPeriod:
                    return ""
            }
        }
    }
}

