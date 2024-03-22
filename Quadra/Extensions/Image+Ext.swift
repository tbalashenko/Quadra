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
    func convert() -> UIImage? {
        let renderer = ImageRenderer(content: self)
        return renderer.uiImage
    }
}
