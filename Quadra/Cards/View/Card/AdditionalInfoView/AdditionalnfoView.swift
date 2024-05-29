//
//  AdditionalnfoView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 26/05/2024.
//

import SwiftUI

struct AdditionalnfoView: View {
    @State var viewModel: AdditionalnfoViewModel
    @State var totalHeight = CGFloat.infinity
    
    var body: some View {
        VStack(alignment: .center) {
            if viewModel.showTranscription {
                Text(viewModel.transcripton)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical)
            }
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(viewModel.additionalInfo, id: \.self) { info in
                        StyledText(description: info.description, value: info.value)
                    }
                }
                Spacer()
            }
            TagCloudView(
                viewModel: TagCloudViewModel(
                    items: viewModel.tags,
                    isSelectable: false),
                totalHeight: $totalHeight
            )
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    AdditionalnfoView()
//}
