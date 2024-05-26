//
//  CardArchiveTag+Ext.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 16/04/2024.
//

import Foundation
import SwiftUI

extension CardArchiveTag {
    static func getColor(for date: Date) -> String {
        switch date.currentMonth() {
            case .january:
                return Color.Month.january.toHex()
            case .february:
                return Color.Month.february.toHex()
            case .march:
                return Color.Month.march.toHex()
            case .april:
                return Color.Month.april.toHex()
            case .may:
                return Color.Month.may.toHex()
            case .june:
                return Color.Month.june.toHex()
            case .july:
                return Color.Month.july.toHex()
            case .august:
                return Color.Month.august.toHex()
            case .september:
                return Color.Month.september.toHex()
            case .october:
                return Color.Month.october.toHex()
            case .november:
                return Color.Month.november.toHex()
            case .december:
                return Color.Month.december.toHex()
        }
    }
}
