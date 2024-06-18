//
//  ChartLine.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 19/04/2024.
//

import Foundation
import SwiftUI

enum ChartLine: String, CaseIterable, Identifiable {
    case totalNumber = "Total number of cards"
    case added = "Number of added cards"
    case deleted = "Number of deleted cards"
    case repeated = "Number of repeated cards"

    var id: String { self.rawValue }

    var color: Color {
        switch self {
            case .totalNumber:
                return .blue
            case .added:
                return .yellow
            case .deleted:
                return .red
            case .repeated:
                return .green
        }
    }

    var gradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [
                    color.opacity(0.5),
                    color.opacity(0.2),
                    color.opacity(0.05)
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
