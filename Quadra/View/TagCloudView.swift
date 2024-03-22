//
//  TagCloudView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 19/03/2024.
//

import SwiftUI

struct TagCloudView: View {
    var max: Int? = nil
    var items: [Source]
    let geometry: GeometryProxy
    var action: ((Int) -> Void)?
    @Binding var totalHeight: CGFloat
    
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
                if let title = items[index].title,
                   let hexColor = items[index].color {
                    TagView(text: title, backgroundColor: Color(hex: hexColor)) {
                        action?(index)
                    }
                        .padding(4)
                        .alignmentGuide(.leading, computeValue: { tagSize in
                            if (abs(width - tagSize.width) > geometry.size.width - 32)
                            {
                                width = 0
                                height -= tagSize.height
                            }
                            let offset = width
                            if index == items.indices.last {
                                width = 0 //last item
                            } else {
                                width -= tagSize.width
                            }
                            return offset
                        })
                        .alignmentGuide(.top, computeValue: {tagSize in
                            let offset = height
                            if index == items.indices.last {
                                height = 0 // last item
                            }
                            return offset
                        })
                }
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

//#Preview {
//    TagCloudView()
//}
