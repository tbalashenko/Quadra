//
//  Font+Ext.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 21/03/2024.
//

import SwiftUI

public extension Font {
    static func customBold(ofSize size: CGFloat) -> Font { return Font.custom("FiraCode-Bold", size: size) }
    static func customRegular(ofSize size: CGFloat) -> Font  {  return Font.custom("FiraCode-Regular", size: size)  }
}
