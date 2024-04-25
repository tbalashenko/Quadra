//
//  UITextView+Ext.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 24/04/2024.
//

import UIKit

extension UITextView {
    func nsRange(from textRange: UITextRange) -> NSRange? {
        let startPosition = offset(from: beginningOfDocument, to: textRange.start)
        let endPosition = offset(from: beginningOfDocument, to: textRange.end)
        return NSRange(location: startPosition, length: endPosition - startPosition)
    }
}
