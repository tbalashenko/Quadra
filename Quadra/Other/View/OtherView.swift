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
                Group {
                    NavigationLink(TextConstants.settings) {
                        SettingsView()
                    }
                    
                    Section(TextConstants.testFeatures) {
                        NavigationLink(TextConstants.getSample) {
                            SamplePhrasesView()
                        }
                        Button("Add random cards") {
                            RandomDataService.shared.addRandomData()
                        }
                    }
                }
                .listRowBackground(Color.dynamicGray)
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
