//
//  PeriodPickerView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 15/05/2024.
//

import SwiftUI

struct PeriodPickerView: View {
    @Binding var selectedPeriod: Period
    
    var body: some View {
        Picker(TextConstants.period, selection: $selectedPeriod) {
            ForEach(Period.allCases) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.menu)
        .styleListSection()
    }
}

#Preview {
    PeriodPickerView(selectedPeriod: .constant(Period.last2Weeks))
}
