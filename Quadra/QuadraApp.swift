//
//  QuadraApp.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI

@main
struct QuadraApp: App {
    @StateObject private var dataController = DataController()
    @StateObject private var settingsManager = SettingsManager()
    @State private var selectedTab = 0
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                ContentView()
                    .tabItem { Image(systemName: "repeat") }
                    .environmentObject(dataController)
                    .environmentObject(settingsManager)
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .tag(0)
                ListView()
                    .tabItem { Image(systemName: "list.bullet") }
                    .environmentObject(dataController)
                    .environmentObject(settingsManager)
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .tag(1)
                StatView()
                    .tabItem { Image(systemName: "chart.xyaxis.line") }
                    .environmentObject(dataController)
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .tag(2)
                OtherView()
                    .tabItem { Image(systemName: "gearshape") }
                    .environmentObject(dataController)
                    .environmentObject(settingsManager)
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .tag(3)
            }
        }
    }
}
