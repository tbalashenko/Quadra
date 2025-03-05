//
//  CardStatus.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 19/03/2024.
//

import Foundation
import SwiftUI

enum CardStatus: Int, CaseIterable {
    case input = 0
    case nextDay
    case day7 = 7
    case day30 = 30
    case day60 = 60
    case day90 = 90
    case archive
    
    var title: String {
        switch self {
            case .input:
                TextConstants.input
            case .nextDay:
                TextConstants.nextDay
            case .day7:
                TextConstants.day7
            case .day30:
                TextConstants.day30
            case .day60:
                TextConstants.day60
            case .day90:
                TextConstants.day90
            case .archive:
                TextConstants.archive
        }
    }
    
    var color: Color {
        switch self {
            case .input:
                Color.Status.ashGray0
            case .nextDay:
                Color.Status.ashGray1
            case .day7:
                Color.Status.ashGray2
            case .day30:
                Color.Status.ashGray3
            case .day60:
                Color.Status.ashGray4
            case .day90:
                Color.Status.ashGray5
            case .archive:
                Color.spanishGray
        }
    }
    
    var hexColor: String { color.toHex() }
}

// MARK: - Identifiable
extension CardStatus: Identifiable {
    var id: Int {
        return self.rawValue
    }
}
