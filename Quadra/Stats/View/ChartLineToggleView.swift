//
//  ChartLineToggleView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 15/05/2024.
//

import SwiftUI

struct ChartLineToggleView: View {
    var toggleBindings: [Binding<Bool>]
    
    var body: some View {
        ForEach(ChartLine.allCases.indices, id: \.self) { index in
            Toggle(ChartLine.allCases[index].rawValue, isOn: toggleBindings[index])
                .tint(ChartLine.allCases[index].color.opacity(0.3))
        }
        .styleListSection()
    }
}

#Preview {
    let toggle1 = Binding<Bool>(get: { false }, set: { _ in })
    let toggle2 = Binding<Bool>(get: { true }, set: { _ in })
    let toggle3 = Binding<Bool>(get: { true }, set: { _ in })
    let toggle4 = Binding<Bool>(get: { true }, set: { _ in })
    
    let toggleBindings: [Binding<Bool>] = [toggle1, toggle2, toggle3, toggle4]
    
    return ChartLineToggleView(toggleBindings: toggleBindings)
}
