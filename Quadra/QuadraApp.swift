//
//  QuadraApp.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI

@main
struct QuadraApp: App {
    @StateObject private var manager: DataManager = DataManager()
    @State private var selectedTab = 0

    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                ContentView()
                    .tabItem {
                        Image(systemName: "repeat")
                    }
                    .tag(0)
                ListView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                    }
                    .tag(1)
            }
            .onAppear(perform: {
                for family: String in UIFont.familyNames {
                    print(family)
                    for names: String in UIFont.fontNames(forFamilyName: family) {
                        print("  \(names)")
                    }
                }
            })
            .environmentObject(manager)
            .environment(\.managedObjectContext, manager.container.viewContext)
        }
    }
}
