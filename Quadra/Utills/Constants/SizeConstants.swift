//
//  SizeConstants.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 06/05/2024.
//

import SwiftUI

struct SizeConstants {
    static var buttonWith: CGFloat {
        UIScreen.main.bounds.width * 0.6
    }
    
    static var buttonHeigh: CGFloat {
        return 40
    }
    
    static var cardWith: CGFloat {
        UIScreen.main.bounds.width * 0.8
    }
    
    static var cardHeigh: CGFloat {
        UIScreen.main.bounds.height * 0.7
    }
    
    static var screenCutOff: CGFloat {
        cardWith * 0.8
    }
    
    static var cornerRadius: CGFloat {
        return 8
    }
}
