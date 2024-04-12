//
//  TagCloudView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 19/03/2024.
//

import SwiftUI

protocol TagCloudViewItem {
    var title: String { get set }
    var color: String { get set }
}

struct TagCloudItem: TagCloudViewItem {
    var title: String
    var color: String
}

extension ItemSource: TagCloudViewItem { }

struct TagCloudView: View {
    var max: Int?
    var items: [TagCloudViewItem]
    let geometry: GeometryProxy
    @Binding var totalHeight: CGFloat
    var inactiveColor: Color?
    var action: ((Int) -> Void)?

    var body: some View {
        generateContent()
            .background(viewHeightReader($totalHeight))
    }

    private func generateContent() -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        var items = self.items

        if let max = max, max < items.count {
            items = Array(items.prefix(max))
        }

        return ZStack(alignment: .topLeading) {
            ForEach(items.indices, id: \.self) { index in
                    TagView(text: items[index].title,
                            backgroundColor: inactiveColor ?? Color(hex: items[index].color)) {
                        action?(index)
                    }
                        .padding(4)
                        .alignmentGuide(.leading, computeValue: { tagSize in
                            if abs(width - tagSize.width) > geometry.size.width * 0.85 {
                                width = 0
                                height -= tagSize.height
                            }
                            let offset = width
                            if index == items.indices.last {
                                width = 0  // last item
                            } else {
                                width -= tagSize.width
                            }
                            return offset
                        })
                        .alignmentGuide(.top, computeValue: {_ in
                            let offset = height
                            if index == items.indices.last {
                                height = 0 // last item
                            }
                            return offset
                        })
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

// #Preview {
//    TagCloudView()
// }
