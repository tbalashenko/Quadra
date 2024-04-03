//
//  Item+ex.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import Foundation
import CoreData
import SwiftUI

extension Source {
    static var source1 = Source(title: "XCode", color: .catawba)
    static var source2 = Source(title: "PE", color: .whiteCoffee)
    static var source3 = Source(title: "SATS", color: .dustRose)
    static var source4 = Source(title: "XCode334", color: .catawba)
    static var source5 = Source(title: "PEfw", color: .whiteCoffee)
    static var source6 = Source(title: "SATSwfewf", color: .puce)
}

extension Item {
    var needSetNewStatus: Bool {
        self.needMoveToThisWeek || self.needMoveToThisMonth || self.needMoveToArchive
    }

    var getNewStatus: Status {
        if self.needMoveToThisWeek {
            return .thisWeek
        } else if self.needMoveToThisMonth {
            return .thisMonth
        } else if self.needMoveToArchive {
            return .archive
        }

        return status
    }

    static var sampleData = [Item(image: UIImage(named: "test")?.pngData(),
                                  archiveTag: "#2024-2",
                                  // audioNote: nil,
                                  phraseToRemember: "Connection interrupted: will attempt to reconnect",
                                  translation: "Соединение прервано: будет предпринята попытка восстановить",
                                  lastRepetition: Date(),
                                  sources: [Source.source1,
                                           Source.source2,
                                           Source.source3,
                                           Source.source4,
                                           Source.source5,
                                           Source.source6],
                                  transcription: "ejfiwje",
                                  status: .input),
                             Item(image: UIImage(named: "test2")?.pngData(),
                                  archiveTag: "#2024-1",
                                  // audioNote: nil,
                                  phraseToRemember: "Message from debugger: killed",
                                  translation: "Сообщение от дебаггера: убито",
                                  lastRepetition: Date(),
                                  sources: [Source.source1],
                                  transcription: "IUHIUHI",
                                  status: .input),
                             Item(image: UIImage(named: "test")?.pngData(),
                                  archiveTag: "#2024-1",
                                  // audioNote: nil,
                                  phraseToRemember: "Message from debugger: killed",
                                  translation: "Сообщение от дебаггера: убито",
                                  lastRepetition: Date(),
                                  sources: [Source.source2],
                                  transcription: "IUHIUHI",
                                  status: .input),
                             Item(image: UIImage(named: "test2")?.pngData(),
                                  archiveTag: "#2024-1",
                                  // audioNote: nil,
                                  phraseToRemember: "Message from debugger: killed",
                                  translation: "Сообщение от дебаггера: убито",
                                  lastRepetition: Date(),
                                  sources: [Source.source1,
                                           Source.source2,
                                           Source.source3],
                                  transcription: "IUHIUHI",
                                  status: .input)]
}

extension Item {
    convenience init(image: Data?,
                     archiveTag: String,
                     phraseToRemember: String,
                     translation: String,
                     lastRepetition: Date,
                     sources: [Source],
                     transcription: String?,
                     additionTime: Date = Date(),
                     status: Status) {
        let entity = NSEntityDescription.entity(forEntityName: "Item",
                                                in: CardManager().container.viewContext)
        self.init(entity: entity!, insertInto: CardManager().container.viewContext)
        self.id = UUID()
        self.archiveTag = archiveTag
        self.phraseToRemember = phraseToRemember
        self.translation = translation
        self.image = image
        self.lastRepetition = lastRepetition
        self.sources = NSSet(array: sources)
        self.transcription = transcription
        self.additionTime = additionTime
        self.status = status
        self.isReadyToRepeat = true
        self.needMoveToThisMonth = false
        self.needMoveToThisWeek = false
        self.needMoveToArchive = false
        self.isArchived = false
        self.lastTimeStatusChanged = Date()
        self.repetitionCounter = 0
    }
}
