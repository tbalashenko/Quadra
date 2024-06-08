//
//  OtherView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 03/04/2024.
//

import SwiftUI

struct OtherView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(TextConstants.settings) {
                    SettingsView()
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.element)
            .navigationTitle(TextConstants.other)
        }
    }
}

#Preview {
    OtherView()
}
