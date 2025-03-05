//
//  RandomDataService.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 10/06/2024.
//

import Foundation

final class RandomDataService {
    static let shared = RandomDataService()

    private init() { }

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

            if let statData = StatDataService.shared.statData.first(where: { $0.date == currentDate }) {
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
                    try _ = StatDataService.shared.saveStatData(
                        date: currentDate ?? Date(),
                        repeatedItemsCounter: Int.random(in: 1...5),
                        addedItemsCounter: Int.random(in: 1...3),
                        deletedItemsCounter: Int.random(in: 0...1))
                } catch {
                    print("Error saving stat data: \(error.localizedDescription)")
                }
            }
        }
    }
}
