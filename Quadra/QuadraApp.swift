//
//  QuadraApp.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI

@main
struct QuadraApp: App {
    @StateObject private var dataManager = DataManager()
    @State private var selectedTab = 0

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                ContentView()
                    .tabItem { Image(systemName: "repeat") }.tag(0)
                    
                ListView()
                    .tabItem { Image(systemName: "list.bullet") }.tag(1)
            }
            .onAppear {
                dataManager.performCheсks()
            }
        }
        .environmentObject(dataManager)
        .environment(\.managedObjectContext, dataManager.container.viewContext)
    }
}
