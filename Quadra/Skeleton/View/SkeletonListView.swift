//
//  SkeletonListView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 13/07/2024.
//

import SwiftUI

struct SkeletonListView: View {
    @Binding var isPresented: Bool
    
    private var currentOpacity: CGFloat { isPresented ? 1 : 0 }
    
    var body: some View {
        List {
            ForEach(0..<10) { _ in
                SkeletonListRowView()
                    .customListRow()
            }
        }
        .customListStyle()
        .opacity(currentOpacity)
        .animation(.easeInOut, value: currentOpacity)
    }
}

#Preview {
    SkeletonListView(isPresented: .constant(true))
}
