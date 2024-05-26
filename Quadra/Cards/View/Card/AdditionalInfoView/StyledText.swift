//
//  StyledText.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 26/05/2024.
//

import SwiftUI

struct StyledText: View {
    let description: String
    let value: String

    var body: some View {
        HStack {
            Text(description)
                .bold()
            Text(value)
        }
    }
}

#Preview {
    StyledText(description: "Test", value: "Test1")
}
