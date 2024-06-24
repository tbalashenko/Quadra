//
//  AdditionalnfoView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 26/05/2024.
//

import SwiftUI

struct AdditionalnfoView: View {
    @ObservedObject var model: CardModel

    var body: some View {
        VStack(alignment: .center) {
            if let transcripton = model.card.formattedTranscription {
                Text(transcripton)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical, 8)
                    .font(.body)
            }
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(model.additionalInfo, id: \.self) { info in
                        StyledText(description: info.description, value: info.value)
                    }
                }
                Spacer()
            }
            .padding(.top, model.card.formattedTranscription != nil ? 0 : 8)
            TagCloudView(
                viewModel: TagCloudViewModel(
                    items: model.tags,
                    isSelectable: false
                )
            )
        }
        .padding(.horizontal)
    }
}

// #Preview {
//    AdditionalnfoView()
// }
