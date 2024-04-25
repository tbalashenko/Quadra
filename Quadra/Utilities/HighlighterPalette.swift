//
//  HighlighterPalette.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 24/04/2024.
//

import UIKit

enum HighliterPalette: Int, CaseIterable {
    case pale = 0, bright
    
    var title: String {
        switch self {
            case .pale:
                return "Pale"
            case .bright:
                return "Bright"
        }
    }
    
    var colors: [UIColor] {
        switch self {
            case .pale:
                return [
                    UIColor.HighliterPale.calmingMint,
                    UIColor.HighliterPale.teaGreen,
                    UIColor.HighliterPale.columbiaBlue,
                    UIColor.HighliterPale.languidLavender,
                    UIColor.HighliterPale.queenPink,
                    UIColor.HighliterPale.veryPaleYellow
                ]
            case .bright:
                return [
                    UIColor.HighliterBright.blue,
                    UIColor.HighliterBright.green,
                    UIColor.HighliterBright.orange,
                    UIColor.HighliterBright.pink,
                    UIColor.HighliterBright.red,
                    UIColor.HighliterBright.yellow
                ]
        }
    }
}
