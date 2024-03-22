//
//  Item+ex.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import Foundation
import CoreData
import SwiftUI

extension Item {
    //    static func getAllItems() -> [Item] {
    //        let context = PersistenceController.shared.container.viewContext
    //        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
    //        do {
    //            let items = try context.fetch(fetchRequest)
    //            return items
    //        }
    //        catch let error as NSError {
    //            print("Error getting ShoppingItems: \(error.localizedDescription), \(error.userInfo)")
    //        }
    //        return [Item]()
    //    }
    //
    //    static func addNewItem(item: Item) -> Item {
    //        let context = PersistenceController.shared.container.viewContext
    //        let newItem = Item(context: context)
    //        newItem.id = UUID()
    //        newItem.timestamp = Date()
    //        return newItem
    //    }
    //
    //    static func saveChanges() {
    //        PersistenceController.shared.saveContext()
    //    }
    //
    //    static func delete(item: Item) {
    //        PersistenceController.shared.container.viewContext.delete(item)
    //        saveChanges()
    //    }
}

extension Source {
    static var source1 = Source(title: "XCode", color: .catawba)
    static var source2 = Source(title: "PE", color: .whiteCoffee)
    static var source3 = Source(title: "SATS", color: .dustRose)
    static var source4 = Source(title: "XCode334", color: .catawba)
    static var source5 = Source(title: "PEfw", color: .whiteCoffee)
    static var source6 = Source(title: "SATSwfewf", color: .puce)
}

extension Item {
    static var sampleData = [Item(image: UIImage(named: "test")?.pngData(),
                                  //archiveTag: "#2024-2",
                                  //audioNote: nil,
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
                                  //archiveTag: "#2024-1",
                                  //audioNote: nil,
                                  phraseToRemember: "Message from debugger: killed",
                                  translation: "Сообщение от дебаггера: убито",
                                  lastRepetition: Date(),
                                  sources: [Source.source1],
                                  transcription: "IUHIUHI",
                                  status: .input),
                             Item(image: UIImage(named: "test")?.pngData(),
                                  //archiveTag: "#2024-1",
                                  //audioNote: nil,
                                  phraseToRemember: "Message from debugger: killed",
                                  translation: "Сообщение от дебаггера: убито",
                                  lastRepetition: Date(),
                                  sources: [Source.source2],
                                  transcription: "IUHIUHI",
                                  status: .input),
                             Item(image: UIImage(named: "test2")?.pngData(),
                                  //archiveTag: "#2024-1",
                                  //audioNote: nil,
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
//                     archiveTag: String,
//                     archiveTagColor: Color = .blue,
                     //                     audioNote: Data?,
                     phraseToRemember: String,
                     translation: String,
                     lastRepetition: Date,
                     sources: [Source],
                     transcription: String?,
                     additionTime: Date = Date(),
                     status: Status) {
        let entity = NSEntityDescription.entity(forEntityName: "Item",
                                                in: DataManager.shared.container.viewContext)
        self.init(entity: entity!, insertInto: DataManager.shared.container.viewContext)
        self.id = UUID()
        //self.archiveTag = ArchiveTag(title: archiveTag, color: archiveTagColor)
        //        self.audioNote = audioNote
        self.phraseToRemember = phraseToRemember
        self.translation = translation
        self.image = image
        self.lastRepetition = lastRepetition
        self.sources = NSSet(array: sources)
        self.transcription = transcription
        self.additionTime = additionTime
        self.status = status
    }
}


