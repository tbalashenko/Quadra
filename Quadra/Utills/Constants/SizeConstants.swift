//
//  SizeConstants.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 06/05/2024.
//

import SwiftUI

struct SizeConstants {
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    static let screenHeigh: CGFloat = UIScreen.main.bounds.height

    static let cornerRadius: CGFloat = 8

    // MARK: - Buttons
    static let plainButtonSize = CGSize(width: buttonWith, height: buttonHeigh)
    static let buttonHeigh: CGFloat = 40.0
    static var buttonWith: CGFloat = UIScreen.main.bounds.width * 0.6
    static let smallButtonImageSize: CGSize = CGSize(width: 22, height: 22)
    static let mediumButtonImageSize: CGSize = CGSize(width: 38, height: 38)
    static let buttonPadding: CGFloat = 4

    // MARK: - Cards
    static var cardWith: CGFloat = UIScreen.main.bounds.width - 2 * horizontalPadding
    static var cardHeigh: CGFloat = UIScreen.main.bounds.height * 0.7
    static var cardSize: CGSize = CGSize(width: cardWith, height: cardHeigh)

    static var screenCutOff: CGFloat = cardWith * 0.4

    static var imageSize: CGSize {
        CGSize(width: imageWith, height: imageHeigh)
    }

    static var imageHeigh: CGFloat {
        imageWith * SettingsManager.shared.aspectRatio.ratio
    }
    static var imageWith: CGFloat = UIScreen.main.bounds.width - 2 * horizontalPadding

    static let horizontalPadding: CGFloat = 32
    static let listHorizontalPadding: CGFloat = 16
    
    static var listImageSize: CGSize {
        CGSize(width: listImageWidth, height: listImageHeigh)
    }
    
    static let listImageHeigh: CGFloat = 88
    
    static var listImageWidth: CGFloat {
        listImageHeigh / SettingsManager.shared.aspectRatio.ratio
    }
    
    static var listImageFullSize: CGSize {
        CGSize(width: listRowWidth, height: listRowWidth * SettingsManager.shared.aspectRatio.ratio)
    }
    
    static var listRowWidth: CGFloat = UIScreen.main.bounds.width - 16
    
}
