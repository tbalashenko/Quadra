//
//  Source.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/03/2024.


import CoreData
import SwiftUI

extension Source {
    convenience init(id: UUID = UUID(), title: String, color: Color) {
        let entity = NSEntityDescription.entity(forEntityName: "Source",
                                                in: DataManager().container.viewContext)
        self.init(entity: entity!, insertInto: DataManager().container.viewContext)
        self.id = id
        self.title = title
        self.color = color.toHex()
    }
}

extension Source: Comparable {
    public static func < (lhs: Source, rhs: Source) -> Bool {
        return lhs.id < rhs.id
    }
}
