//
//  ItemSource+CoreDataProperties.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 11/04/2024.
//
//

import Foundation
import CoreData


extension ItemSource {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemSource> {
        return NSFetchRequest<ItemSource>(entityName: "ItemSource")
    }

    @NSManaged public var color: String
    @NSManaged public var id: UUID
    @NSManaged public var title: String

}

extension ItemSource : Identifiable {

}
