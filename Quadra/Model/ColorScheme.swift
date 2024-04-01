//
//  ColorScheme.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import Foundation
import SwiftUI

enum ColorScheme {
    case def

    var accentColor: Color {
        switch self {
            case .def:
                return Color.catawba
        }
    }

    var secondColor: Color {
        switch self {
            case .def:
                return Color.dustRose
        }
    }

    var thirdColor: Color {
        switch self {
            case .def:
                return Color.morningBlue
        }
    }

    var fourthColor: Color {
        switch self {
            case .def:
                return Color.puce
        }
    }

    var backgroundColor: Color {
        switch self {
            case .def:
                return Color.whiteCoffee
        }
    }
}
