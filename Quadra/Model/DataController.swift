//
//  DataController.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import UIKit
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Quadra")
    
    init() {
        let name = NSValueTransformerName(rawValue: String(describing: AttributedStringTransformer.self))
        ValueTransformer.setValueTransformer(AttributedStringTransformer(), forName: name)
        
        ValueTransformer.setValueTransformer(StatusTransformer(), forName: NSValueTransformerName("StatusTransformer"))
        guard let persistentStoreDescriptions = container.persistentStoreDescriptions.first else {
            fatalError("\(#function): Failed to retrieve a persistent store description.")
        }
        persistentStoreDescriptions.setOption(true as NSNumber,
                                              forKey: NSPersistentHistoryTrackingKey)
        persistentStoreDescriptions.setOption(true as NSNumber,
                                              forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
