//
//  QuadraApp.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI

@main
struct QuadraApp: App {
    @State private var selectedTab = 0
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                ContentView()
                    .tabItem { Image(systemName: "repeat") }
                    .tag(0)
                ListView()
                    .tabItem { Image(systemName: "list.bullet") }
                    .tag(1)
                StatView()
                    .tabItem { Image(systemName: "chart.xyaxis.line") }
                    .tag(2)
                OtherView()
                    .tabItem { Image(systemName: "gearshape") }
                    .tag(3)
            }
        }
    }
}
