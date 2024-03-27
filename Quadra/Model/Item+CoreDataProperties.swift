//
//  Item+CoreDataProperties.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 19/03/2024.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var additionTime: Date
    @NSManaged public var id: UUID
    @NSManaged public var image: Data?
    @NSManaged public var lastRepetition: Date?
    @NSManaged public var phraseToRemember: String
    @NSManaged public var translation: String?
    @NSManaged public var transcription: String?
    @NSManaged public var repetitionCounter: Int64
    @NSManaged public var status: Status
    @NSManaged public var sources: NSSet?
    @NSManaged public var archiveTag: String
    @NSManaged public var isArchived: Bool
    @NSManaged public var needMoveToThisWeek: Bool
    @NSManaged public var needMoveToThisMonth: Bool
    @NSManaged public var needMoveToArchive: Bool
    @NSManaged public var mustBeDeleted: Bool
}

// MARK: Generated accessors for sources
extension Item {

    @objc(addSourcesObject:)
    @NSManaged public func addToSources(_ value: Source)

    @objc(removeSourcesObject:)
    @NSManaged public func removeFromSources(_ value: Source)

    @objc(addSources:)
    @NSManaged public func addToSources(_ values: NSSet)

    @objc(removeSources:)
    @NSManaged public func removeFromSources(_ values: NSSet)

}

extension Item : Identifiable {

}
