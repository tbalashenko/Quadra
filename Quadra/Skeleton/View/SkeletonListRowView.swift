//
//  SkeletonListRowView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 08/04/2024.
//

import SwiftUI

struct SkeletonListRowView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                SkeletonView()
                    .frame(height: 22)
                    .padding([.top, .leading])
                SkeletonView()
                    .frame(width: 100,
                           height: 22)
                    .padding([.leading, .bottom])
            }
            SkeletonView()
                .frame(width: 88, height: 88)
        }
        .background(Color.element
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .northWestShadow()
        )
    }
}

#Preview {
    List {
        ForEach(0..<10) { _ in
            SkeletonListRowView()
                .listRowSeparator(.hidden)
                .listRowBackground(Color.element)
        }
    }
    .listStyle(.plain)
}
