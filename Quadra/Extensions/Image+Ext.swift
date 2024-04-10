//
//  Image+Ext.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 18/03/2024.
//

import UIKit
import SwiftUI

extension Image {
    @MainActor
    func convert(scale: ImageScale) -> UIImage? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = scale.rawValue
        return renderer.uiImage
    }
}
