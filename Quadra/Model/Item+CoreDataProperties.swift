//
//  Item+CoreDataProperties.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 16/04/2024.
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
    @NSManaged public var isArchived: Bool
    @NSManaged public var isReadyToRepeat: Bool
    @NSManaged public var lastRepetition: Date?
    @NSManaged public var lastTimeStatusChanged: Date?
    @NSManaged public var needMoveToArchive: Bool
    @NSManaged public var needMoveToThisMonth: Bool
    @NSManaged public var needMoveToThisWeek: Bool
    @NSManaged public var phraseToRemember: NSAttributedString
    @NSManaged public var repetitionCounter: Int
    @NSManaged public var status: Status
    @NSManaged public var transcription: String?
    @NSManaged public var translation: NSAttributedString?
    @NSManaged public var sources: NSSet?
    @NSManaged public var archiveTag: ItemArchiveTag

}

// MARK: Generated accessors for sources
extension Item {

    @objc(addSourcesObject:)
    @NSManaged public func addToSources(_ value: ItemSource)

    @objc(removeSourcesObject:)
    @NSManaged public func removeFromSources(_ value: ItemSource)

    @objc(addSources:)
    @NSManaged public func addToSources(_ values: NSSet)

    @objc(removeSources:)
    @NSManaged public func removeFromSources(_ values: NSSet)

}

extension Item : Identifiable {

}
