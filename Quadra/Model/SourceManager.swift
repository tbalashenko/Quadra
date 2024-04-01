//
//  SourceManager.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 31/03/2024.
//

import UIKit
import CoreData

class SourceManager: NSObject, ObservableObject {
    @Published var sources: [Source] = [Source]()

    let container: NSPersistentContainer = NSPersistentContainer(name: "Quadra")

    override init() {
        super.init()
        ValueTransformer.setValueTransformer(StatusTransformer(), forName: NSValueTransformerName("StatusTransformer"))
        container.loadPersistentStores { _, _ in }
    }

    func fetchSources() -> [Source] {
        do {
            let fetchRequest: NSFetchRequest<Source> = Source.fetchRequest()
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching items: \(error)")
            return []
        }
    }
}
