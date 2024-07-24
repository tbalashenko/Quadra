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
        var predicate: NSPredicate?
        if let fromDate {
            predicate = NSPredicate(format: "date >= %@ AND date <= %@", fromDate as NSDate, Date() as NSDate)
        }

        guard let data = try? StatDataService.shared.fetchStatData(sortDescriptors: [sortDescriptor], predicate: predicate) else { return }

        statData = data
    }
}
