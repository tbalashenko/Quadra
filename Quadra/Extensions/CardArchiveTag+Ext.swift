//
//  CardArchiveTag+Ext.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 16/04/2024.
//

import SwiftUI

extension CardArchiveTag {
    static func getColor(for date: Date) -> String {
        let monthColors = [
            Color.Month.january,
            Color.Month.february,
            Color.Month.march,
            Color.Month.april,
            Color.Month.may,
            Color.Month.june,
            Color.Month.july,
            Color.Month.august,
            Color.Month.september,
            Color.Month.october,
            Color.Month.november,
            Color.Month.december
        ]
        
        let monthIndex = Calendar.current.component(.month, from: date) - 1
        return monthColors[monthIndex].toHex()
    }
}

