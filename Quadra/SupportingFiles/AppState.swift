//
//  AppState.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 05/07/2024.
//

import Foundation

enum AppTab: Int {
    case cards = 0, list, stat, settings
}

class AppState: ObservableObject {
    @Published var selectedTab: AppTab = .cards
    
    static let shared = AppState()
    
    private init() { }
}
