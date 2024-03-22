//
//  Status+Ext.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 19/03/2024.
//

import Foundation
import SwiftUI
import CoreData

public class Status: NSObject, NSCoding, NSSecureCoding {
    public static var supportsSecureCoding: Bool {
        return true
    }
    
    let title: String
    let color: String
    
    init(title: String, color: Color) {
        self.title = title
        self.color = color.toHex()
    }
    
    public required init?(coder: NSCoder) {
        guard let title = coder.decodeObject(of: NSString.self, forKey: "title") as String?,
              let color = coder.decodeObject(of: NSString.self, forKey: "color") as String?
        else {
            return nil
        }
        self.title = title
        self.color = color
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(color, forKey: "color")
    }
    
    public static let input = Status(title: "#input", color: Color.Green.isabelline)
    public static let thisWeek = Status(title: "#thisWeek", color: Color.Green.gainsboro)
    public static let thisMonth = Status(title: "#thisMonth", color: Color.Green.ashGray)
    public static let archive = Status(title: "#archive", color: Color.Green.darkSeaGreen)
}

public class StatusTransformer: ValueTransformer {
    public override func transformedValue(_ value: Any?) -> Any? {
        guard let status = value as? Status else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: status, requiringSecureCoding: true)
            return data
        } catch {
            return nil
        }
    }
    
    public override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            let status =  try NSKeyedUnarchiver.unarchivedObject(ofClass: Status.self, from: data)
            return status
        } catch {
            return nil
        }
    }
}
