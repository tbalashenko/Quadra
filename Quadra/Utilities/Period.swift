//
//  Period.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 17/04/2024.
//

import Foundation
import Charts
import SwiftUI

enum Period: String, CaseIterable, Identifiable {
    case lastYear = "Last Year"
    case last6months = "Last 6 Months"
    case last3months = "Last 3 Months"
    case lastMonth = "Last Month"
    case last2Weeks = "Last 2 Weeks"
    case lastWeek = "Last Week"
    
    var id: String { self.rawValue }
    
    var fromDate: Date {
        let toDate = Date()
        let calendar = Calendar.current
        
        switch self {
            case .lastYear:
                return calendar.date(byAdding: .year, value: -1, to: toDate) ?? Date()
            case .last6months:
                return calendar.date(byAdding: .month, value: -6, to: toDate) ?? Date()
            case .last3months:
                return calendar.date(byAdding: .month, value: -3, to: toDate) ?? Date()
            case .lastMonth:
                return calendar.date(byAdding: .month, value: -1, to: toDate) ?? Date()
            case .last2Weeks:
                return calendar.date(byAdding: .day, value: -14, to: toDate) ?? Date()
            case .lastWeek:
                return calendar.date(byAdding: .day, value: -7, to: toDate) ?? Date()
        }
    }
    
    var axisMarksValues: AxisMarkValues {
        switch self {
            case .lastYear:
                return .stride(by: .day, count: 7)
            case .last6months:
                return .stride(by: .day, count: 7)
            case .last3months:
                return .stride(by: .day, count: 7)
            case .lastMonth, .last2Weeks, .lastWeek:
                return .stride(by: .day, count: 1)
        }
    }
    
    var chartXVisibleDomainLength: Int {
        switch self {
            case .lastYear:
                return 86400 * 30
            case .last6months:
                return 86400 * 30
            case .last3months:
                return 86400 * 30
            case .lastMonth, .last2Weeks, .lastWeek:
                return 86400 * 7
        }
    }
}
