//
//  AspectRatio.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 09/04/2024.
//

import Foundation

enum AspectRatio: String, CaseIterable, RawRepresentable {
    case sixteenToNine = "16:9"
    case fourToThree = "4:3"
    case oneToOne = "1:1"
    case twoToOne = "2:1"

    var ratio: CGFloat {
        switch self {
            case .sixteenToNine:
                return 9/16
            case .fourToThree:
                return 3/4
            case .oneToOne:
                return 1
            case .twoToOne:
                return 1/2
        }
    }
}
