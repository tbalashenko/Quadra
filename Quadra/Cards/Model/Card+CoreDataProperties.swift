//
//  Card+CoreDataProperties.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 16/05/2024.
//
//

import Foundation
import CoreData

extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var additionTime: Date
    @NSManaged public var id: UUID
    @NSManaged public var image: Data?
    @NSManaged public var croppedImage: Data?
    @NSManaged public var isArchived: Bool
    @NSManaged public var lastRepetition: Date?
    @NSManaged public var lastTimeStatusChanged: Date?
    @NSManaged public var phraseToRemember: NSAttributedString
    @NSManaged public var repetitionCounter: Int
    @NSManaged public var cardStatus: CardStatus
    @NSManaged public var transcription: String?
    @NSManaged public var translation: NSAttributedString?
    @NSManaged public var sources: NSSet?
    @NSManaged public var archiveTag: CardArchiveTag?

}

// MARK: Generated accessors for sources
extension Card {

    @objc(addSourcesObject:)
    @NSManaged public func addToSources(_ value: CardSource)

    @objc(removeSourcesObject:)
    @NSManaged public func removeFromSources(_ value: CardSource)

    @objc(addSources:)
    @NSManaged public func addToSources(_ values: NSSet)

    @objc(removeSources:)
    @NSManaged public func removeFromSources(_ values: NSSet)

}

extension Card: Identifiable {

}
