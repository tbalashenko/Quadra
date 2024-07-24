//
//  Dictionary+Ext.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 24/07/2024.
//

import Foundation

extension Dictionary where Key == CardStatus, Value == [Card] {
    func isEqual(to other: [CardStatus: [Card]]) -> Bool {
        guard self.keys == other.keys else {
            return false
        }
        
        for key in self.keys {
            if self[key]?.map({ $0.id }) != other[key]?.map({ $0.id }) {
                return false
            }
        }
        
        return true
    }
}
