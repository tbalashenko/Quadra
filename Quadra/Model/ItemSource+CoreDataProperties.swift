//
//  ItemSource+CoreDataProperties.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 12/04/2024.
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
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension ItemSource {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension ItemSource : Identifiable {

}
