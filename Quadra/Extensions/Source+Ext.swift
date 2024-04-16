//
//  Source.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/03/2024.

import CoreData
import SwiftUI

// MARK: - Comparable
extension ItemSource: Comparable {
    public static func < (lhs: ItemSource, rhs: ItemSource) -> Bool {
        return lhs.id < rhs.id
    }
}
