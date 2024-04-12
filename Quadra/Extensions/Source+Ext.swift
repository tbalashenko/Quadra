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

extension ItemSource: Comparable {
    public static func < (lhs: ItemSource, rhs: ItemSource) -> Bool {
        return lhs.id < rhs.id
    }
}
