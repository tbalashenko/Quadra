//
//  TagCloudItem.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 28/05/2024.
//

import Foundation

class TagCloudItem: ObservableObject {
    var isSelected: Bool
    var id: UUID
    var title: String
    var color: String
    var action: (() -> Void)?
    var isExceeded = false
    
    init(isSelected: Bool, id: UUID, title: String, color: String, action: (() -> Void)? = nil) {
        self.isSelected = isSelected
        self.id = id
        self.title = title
        self.color = color
        self.action = action
    }
}

extension TagCloudItem: Identifiable { }

//MARK: - Hashable
extension TagCloudItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}

//MARK: - Equatable
extension TagCloudItem: Equatable {
    static func == (lhs: TagCloudItem, rhs: TagCloudItem) -> Bool {
        return lhs.id == rhs.id &&
        lhs.isSelected == rhs.isSelected &&
        lhs.title == rhs.title &&
        lhs.color == rhs.color
    }
}
