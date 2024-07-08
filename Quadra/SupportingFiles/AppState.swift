//
//  AppState.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 05/07/2024.
//

import Foundation

enum AppTab: Int {
    case review = 0, list, stat, other
}

class AppState: ObservableObject {
    @Published var selectedTab: AppTab = .review
    
    static let shared = AppState()
    
    private init() { }
}
