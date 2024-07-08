//
//  Helpers.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 27/06/2024.
//

import Foundation

protocol TextRepresentable {
    var count: Int { get }
}

final class Helpers {
    static func getErrorMessage<T: TextRepresentable>(for value: T, errorText: inout String, textLimit: Int = SizeConstants.textLimit) {
        if value.count <= SizeConstants.textLimit { errorText = ""; return }
        
        let charactersToRemove = value.count - textLimit
        let characterWordForm = charactersToRemove == 1 ? "character" : "characters"
        errorText = String(format: "The maximum allowed length is %d characters. Please remove %d %@.", textLimit, charactersToRemove, characterWordForm)
    }
}
