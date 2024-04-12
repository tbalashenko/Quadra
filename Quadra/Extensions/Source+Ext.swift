//
//  Source.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/03/2024.

import CoreData
import SwiftUI

extension ItemSource {
    convenience init(id: UUID = UUID(), title: String, color: Color) {
        let entity = NSEntityDescription.entity(forEntityName: "ItemSource",
                                                in: CardManager().container.viewContext)
        self.init(entity: entity!, insertInto: CardManager().container.viewContext)
        self.id = id
        self.title = "#" + title
        self.color = color.toHex()
    }
}

extension ItemSource {
    static var source1 = ItemSource(title: "XCode", color: .catawba)
    static var source2 = ItemSource(title: "PE", color: .whiteCoffee)
    static var source3 = ItemSource(title: "SATS", color: .dustRose)
    static var source4 = ItemSource(title: "Short", color: .catawba)
    static var source5 = ItemSource(title: "LongSourceName", color: .whiteCoffee)
    static var source6 = ItemSource(title: "VeryVeryLongSourceName", color: .puce)
    
    static var previewData: [ItemSource] {
        return [source1, source2, source3, source4, source5, source6]
    }
}

// MARK: - Comparable
extension ItemSource: Comparable {
    public static func < (lhs: ItemSource, rhs: ItemSource) -> Bool {
        return lhs.id < rhs.id
    }
}
