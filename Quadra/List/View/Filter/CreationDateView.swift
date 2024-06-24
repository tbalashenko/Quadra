//
//  CreationDateView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 08/06/2024.
//

import SwiftUI

struct CreationDateView: View {
    @ObservedObject var viewModel: FilterViewModel
    @ObservedObject var filterService = FilterService.shared

    var body: some View {
        Group {
            DatePicker(TextConstants.from,
                       selection: $filterService.fromDate,
                       in: filterService.minDate...filterService.toDate,
                       displayedComponents: [.date])
            
            DatePicker(TextConstants.to,
                       selection: $filterService.toDate,
                       in: filterService.fromDate...filterService.maxDate,
                       displayedComponents: [.date])
        }
        .datePickerStyle(.compact)
        .font(.system(size: 16))
    }
}

// #Preview {
//    CreationDateView()
// }
