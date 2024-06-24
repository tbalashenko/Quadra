//
//  CardStatus.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 19/03/2024.
//

import Foundation
import SwiftUI
import CoreData

enum CardStatus: Int, CaseIterable {
    case input = 0, thisWeek, thisMonth, archive
    
    var title: String {
        switch self {
            case .input:
                TextConstants.input
            case .thisWeek:
                TextConstants.thisWeek
            case .thisMonth:
                TextConstants.thisMonth
            case .archive:
                TextConstants.archive
        }
    }
    
    var color: Color {
        switch self {
            case .input:
                Color.Green.ashGray
            case .thisWeek:
                Color.yellowIris
            case .thisMonth:
                Color.accentOrange
            case .archive:
                Color.spanishGray
        }
    }
}

// MARK: - Identifiable
extension CardStatus: Identifiable {
    var id: Int {
            return self.rawValue
        }
}

//final public class CardStatus: NSObject, NSCoding, NSSecureCoding {
//    public let id: Int
//    let title: String
//    let color: String
//
//    public static let allStatuses = [CardStatus.input, CardStatus.thisWeek, CardStatus.thisMonth, CardStatus.archive]
//
//    public static let input = CardStatus(id: 0, title: TextConstants.input, color: Color.Green.ashGray)
//    public static let thisWeek = CardStatus(id: 1, title: TextConstants.thisWeek, color: Color.yellowIris)
//    public static let thisMonth = CardStatus(id: 2, title: TextConstants.thisMonth, color: Color.accentOrange)
//    public static let archive = CardStatus(id: 3, title: TextConstants.archive, color: Color.spanishGray)
//
//    public static var supportsSecureCoding: Bool { return true }
//
//    private init(id: Int, title: String, color: Color) {
//        self.id = id
//        self.title = title
//        self.color = color.toHex()
//    }
//
//    public required init?(coder: NSCoder) {
//        guard
//            let title = coder.decodeObject(of: NSString.self, forKey: "title") as String?,
//            let color = coder.decodeObject(of: NSString.self, forKey: "color") as String?
//        else { return nil }
//
//        self.id = coder.decodeInteger(forKey: "id")
//        self.title = title
//        self.color = color
//    }
//
//    public func encode(with coder: NSCoder) {
//        coder.encode(id, forKey: "id")
//        coder.encode(title, forKey: "title")
//        coder.encode(color, forKey: "color")
//    }
//
//    // MARK: - Equitable
//    public override func isEqual(_ object: Any?) -> Bool {
//        guard let other = object as? CardStatus else { return false }
//
//        return self.id == other.id
//    }
//
//    // MARK: - Hashable
//    public override var hash: Int {
//        return id.hashValue
//    }
//}
//
//public class StatusTransformer: ValueTransformer {
//    public override func transformedValue(_ value: Any?) -> Any? {
//        guard let status = value as? CardStatus else { return nil }
//
//        do {
//            let data = try NSKeyedArchiver.archivedData(withRootObject: status, requiringSecureCoding: true)
//            return data
//        } catch {
//            return nil
//        }
//    }
//
//    public override func reverseTransformedValue(_ value: Any?) -> Any? {
//        guard let data = value as? Data else { return nil }
//
//        do {
//            let status =  try NSKeyedUnarchiver.unarchivedObject(ofClass: CardStatus.self, from: data)
//            return status
//        } catch {
//            return nil
//        }
//    }
//}
//
//// MARK: - Identifiable
//extension CardStatus: Identifiable { }
