//
//  Persistence.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import UIKit
import CoreData

class DataManager: NSObject, ObservableObject {
    static let shared = DataManager()
    
    @Published var items: [Item] = [Item]()
    @Published var sources: [Source] = [Source]()
    
    let container: NSPersistentContainer = NSPersistentContainer(name: "Quadra")
    
    override init() {
        super.init()
        
        ValueTransformer.setValueTransformer(StatusTransformer(), forName: NSValueTransformerName("StatusTransformer"))
        container.loadPersistentStores { _, _ in }
    }
    
    func deleteObjects() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            let items = try container.viewContext.fetch(fetchRequest)
            for item in items {
                container.viewContext.delete(item)
            }
            
            try container.viewContext.save()
        } catch {
            print("Error deleting objects: \(error.localizedDescription)")
        }
    }
    
//    func saveContext () {
//        if container.viewContext.hasChanges {
//            do {
//                try container.viewContext.save()
//            } catch let error as NSError {
//                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
//            }
//        }
//    }
}
