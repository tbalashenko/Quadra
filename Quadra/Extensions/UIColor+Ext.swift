//
//  UIColor+Ext.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 24/04/2024.
//

import UIKit

extension UIColor {
    private enum Light {
        static let black = UIColor(hex: "0x212121")
        static let white = UIColor(hex: "0xFFFFFF")
    }

    private enum Dark {
        static let black = UIColor(hex: "0x1F1F1F")
        static let white = UIColor(hex: "0xFFFFFF")
    }

    // dynamic colors
    static let black = UIColor(light: Light.black, dark: Dark.white)
    static let white = UIColor(light: Light.white, dark: Dark.black)

    convenience init(light: UIColor, dark: UIColor) {
        self.init { $0.userInterfaceStyle == .dark ? dark : light }
    }
}

extension UIColor {
    enum HighliterPale {
        static let calmingMint = UIColor(hex: "#C6E5DA")
        static let teaGreen = UIColor(hex: "#C6E5CD")
        static let columbiaBlue = UIColor(hex: "#C6E1E5")
        static let languidLavender = UIColor(hex: "#D1C6E5")
        static let queenPink = UIColor(hex: "#E5C6D1")
        static let veryPaleYellow = UIColor(hex: "#FFFACA")
    }

    enum HighliterBright {
        static let yellow = UIColor(hex: "#FBF719")
        static let blue = UIColor(hex: "#30C5FF")
        static let red = UIColor(hex: "#F72F35")
        static let green = UIColor(hex: "#5DE23C")
        static let orange = UIColor(hex: "#FF793B")
        static let pink = UIColor(hex: "#FA3BF0")
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {
            let red = CGFloat((hexNumber & 0xff0000) >> 16) / 255.0
            let green = CGFloat((hexNumber & 0x00ff00) >> 8) / 255.0
            let blue = CGFloat(hexNumber & 0x0000ff) / 255.0
            self.init(red: red, green: green, blue: blue, alpha: 1.0)
            return
        }

        self.init(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
