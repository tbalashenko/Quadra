//
//  CardArchiveTag+CoreDataProperties.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 16/05/2024.
//
//

import Foundation
import CoreData

extension CardArchiveTag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardArchiveTag> {
        return NSFetchRequest<CardArchiveTag>(entityName: "CardArchiveTag")
    }

    @NSManaged public var color: String
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var cards: NSSet?

}

// MARK: Generated accessors for cards
extension CardArchiveTag {

    @objc(addCardsObject:)
    @NSManaged public func addToCards(_ value: Card)

    @objc(removeCardsObject:)
    @NSManaged public func removeFromCards(_ value: Card)

    @objc(addCards:)
    @NSManaged public func addToCards(_ values: NSSet)

    @objc(removeCards:)
    @NSManaged public func removeFromCards(_ values: NSSet)

}

extension CardArchiveTag: Identifiable {

}
