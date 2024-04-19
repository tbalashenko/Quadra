//
//  StatData+CoreDataProperties.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/04/2024.
//
//

import Foundation
import CoreData


extension StatData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StatData> {
        return NSFetchRequest<StatData>(entityName: "StatData")
    }

    @NSManaged public var date: Date
    @NSManaged public var addedItemsCounter: Int
    @NSManaged public var deletedItemsCounter: Int
    @NSManaged public var repeatedItemsCounter: Int
    @NSManaged public var totalNumberOfCards: Int

}

extension StatData : Identifiable {

}
