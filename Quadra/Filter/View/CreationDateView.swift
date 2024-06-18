//
//  CreationDateView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 08/06/2024.
//

import SwiftUI

struct CreationDateView: View {
    @ObservedObject var viewModel: FilterViewModel

    var body: some View {
        GroupBox(TextConstants.creationDate) {
            DatePicker(TextConstants.from,
                       selection: $viewModel.model.fromDate,
                       in: viewModel.model.minDate...viewModel.model.toDate,
                       displayedComponents: [.date])
            .datePickerStyle(.compact)
            DatePicker(TextConstants.to,
                       selection: $viewModel.model.toDate,
                       in: viewModel.model.fromDate...viewModel.model.maxDate,
                       displayedComponents: [.date])
            .datePickerStyle(.compact)
        }
        .groupBoxStyle(PlainGroupBoxStyle())
    }
}

// #Preview {
//    CreationDateView()
// }
