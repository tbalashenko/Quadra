//
//  CardStatus.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 19/03/2024.
//

import Foundation
import SwiftUI
import CoreData

enum CardStatus: Int, CaseIterable {
    case input = 0, thisWeek, thisMonth, archive
    
    var title: String {
        switch self {
            case .input:
                TextConstants.input
            case .thisWeek:
                TextConstants.thisWeek
            case .thisMonth:
                TextConstants.thisMonth
            case .archive:
                TextConstants.archive
        }
    }
    
    var color: Color {
        switch self {
            case .input:
                Color.Green.ashGray
            case .thisWeek:
                Color.yellowIris
            case .thisMonth:
                Color.accentOrange
            case .archive:
                Color.spanishGray
        }
    }
}

// MARK: - Identifiable
extension CardStatus: Identifiable {
    var id: Int {
            return self.rawValue
        }
}
