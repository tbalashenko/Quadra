//
//  SizeConstants.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 06/05/2024.
//

import SwiftUI

struct SizeConstants {
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    //MARK: - Buttons
    static let buttonHeigh: CGFloat = 40.0
    static var buttonWith: CGFloat {
        UIScreen.main.bounds.width * 0.6
    }
    static let buttonImageHeighWidth: CGFloat = 22.0
    
    
    
    //MARK: - Cards
    
    static let cornerRadius: CGFloat = 8
    
    static var cardWith: CGFloat {
        UIScreen.main.bounds.width * 0.8
    }
    
    static var cardHeigh: CGFloat {
        UIScreen.main.bounds.height * 0.7
    }
    
    static var photoPickerWidth: CGFloat {
        UIScreen.main.bounds.width * 0.9
    }
    
    static var screenCutOff: CGFloat {
        cardWith * 0.8
    }
}
