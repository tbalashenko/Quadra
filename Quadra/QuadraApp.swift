//
//  QuadraApp.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI

@main
struct QuadraApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var cardsViewModel = CardsViewModel()
    @StateObject private var appState = AppState.shared

    var body: some Scene {
        WindowGroup {
            TabView(selection: $appState.selectedTab) {
                ContentView()
                    .environmentObject(cardsViewModel)
                    .tabItem { Image(systemName: "book.pages") }
                    .tag(AppTab.review)
                ListView()
                    .tabItem { Image(systemName: "list.bullet") }
                    .tag(AppTab.list)
                StatView()
                    .tabItem { Image(systemName: "chart.xyaxis.line") }
                    .tag(AppTab.stat)
                OtherView()
                    .tabItem { Image(systemName: "gearshape") }
                    .tag(AppTab.other)
            }
        }
    }
}
