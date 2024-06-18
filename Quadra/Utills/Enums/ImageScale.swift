//
//  ImageScale.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 09/04/2024.
//

import Foundation

enum ImageScale: Double, RawRepresentable, CaseIterable {
    case percent50 = 0.5
    case percent60 = 0.6
    case percent70 = 0.7
    case percent80 = 0.8
    case percent90 = 0.9
    case percent100 = 1.0

    var value: String {
        switch self {
            case .percent50:
                return "50%"
            case .percent60:
                return "60%"
            case .percent70:
                return "70%"
            case .percent80:
                return "80%"
            case .percent90:
                return "90%"
            case .percent100:
                return "100%"
        }
    }
}
