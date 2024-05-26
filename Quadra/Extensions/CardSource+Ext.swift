//
//  CardSource.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/03/2024.

import CoreData
import SwiftUI

// MARK: - Comparable
extension CardSource: Comparable {
    public static func < (lhs: CardSource, rhs: CardSource) -> Bool {
        return lhs.id < rhs.id
    }
}

// MARK: - TagCloudViewItem
extension CardSource: TagCloudViewItem { }
