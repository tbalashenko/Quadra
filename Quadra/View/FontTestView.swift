//
//  FontTestView.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 21/03/2024.
//

import SwiftUI

struct FontTestView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).font(.system(size: 18))
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).font(Font.custom("OpenSans-Regular", size: 18))
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).font(Font.custom("NunitoSans-12ptExtraLight_Regular", size: 18))
        //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).font(Font.custom("Poppins-Regular", size: 18))
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).font(Font.custom("Roboto-Regular", size: 18))
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).font(Font.custom("FiraCode-Regular", size: 18))
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).font(Font.custom("Scada-Regular", size: 18))
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).font(.system(size: 18))
    }
}

#Preview {
    FontTestView()
}
