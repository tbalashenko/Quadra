//
//  AttributedString+Ext.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 23/04/2024.
//

import Foundation

class AttributedStringTransformer: NSSecureUnarchiveFromDataTransformer {
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override class func transformedValueClass() -> AnyClass {
        return NSAttributedString.self
    }
    
    override class var allowedTopLevelClasses: [AnyClass] {
        return [NSAttributedString.self]
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            fatalError("Wrong data type: value must be a Data object; received \(type(of: value))")
        }
        return super.transformedValue(data)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let string = value as? NSAttributedString else {
            fatalError("Wrong data type: value must be a Reminder object; received \(type(of: value))")
        }
        return super.reverseTransformedValue(string)
    }
}
