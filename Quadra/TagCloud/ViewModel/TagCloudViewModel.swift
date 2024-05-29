//
//  TagCloudViewModel.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 28/05/2024.
//

import Foundation

final class TagCloudViewModel: ObservableObject {
    @Published var displayedItems = [TagCloudItem]()
    @Published var items = [TagCloudItem]() {
        didSet {
            updateDisplayedItems()
        }
    }
    let isSelectable: Bool
    let max: Int?
    
    init(items: [TagCloudItem], isSelectable: Bool, max: Int? = nil) {
        self.items = items
        self.isSelectable = isSelectable
        self.max = max
        
        updateDisplayedItems()
    }
    
    func updateDisplayedItems() {
        if let max = max {
            displayedItems = Array(items.prefix(max))
        } else {
            displayedItems = items
        }
        displayedItems = displayedItems.sorted(by: { $0.isSelected && !$1.isSelected })
    }
}
