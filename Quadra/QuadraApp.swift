//
//  QuadraApp.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI

@main
struct QuadraApp: App {
    @StateObject private var cardManager = CardManager()
    @StateObject private var settingsManager = SettingsManager()
    @State private var selectedTab = 0

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                ContentView()
                    .tabItem { Image(systemName: "repeat") }.tag(0)
                    .environmentObject(cardManager)
                    .environmentObject(settingsManager)
                    .environment(\.managedObjectContext, cardManager.container.viewContext)
                ListView()
                    .tabItem { Image(systemName: "list.bullet") }.tag(1)
                    .environmentObject(cardManager)
                    .environmentObject(settingsManager)
                    .environment(\.managedObjectContext, cardManager.container.viewContext)
                OtherView()
                    .tabItem { Image(systemName: "gearshape") }.tag(2)
                    .environmentObject(settingsManager)
                    .environmentObject(cardManager)
                    .environment(\.managedObjectContext, cardManager.container.viewContext)
            }
            .onAppear {
                cardManager.performCheсks()
            }
        }
    }
}
