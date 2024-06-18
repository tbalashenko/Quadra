//
//  UserDefaultsManager.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 03/04/2024.
//

import Foundation

public struct UserDefaultsManager {
    public static func removeObject(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public static func saveObject(_ object: Any?, forKey defaultName: String) {
        UserDefaults.standard.set(object, forKey: defaultName)
        UserDefaults.standard.synchronize()
    }
    
    public static func integerForKey(_ defaultName: String) -> Int? {
        return UserDefaults.standard.object(forKey: defaultName) as? Int
    }
    
    public static func doubleForKey(_ defaultName: String) -> Double? {
        return UserDefaults.standard.object(forKey: defaultName) as? Double
    }
    
    public static func boolForKey(_ defaultName: String) -> Bool? {
        return UserDefaults.standard.object(forKey: defaultName) as? Bool
    }
    
    public static func stringForKey(_ defaultName: String) -> String? {
        return UserDefaults.standard.string(forKey: defaultName)
    }
    
    public static func objectForKey(_ defaultName: String) -> AnyObject? {
        return UserDefaults.standard.object(forKey: defaultName) as? AnyObject
    }
}

struct UserDefaultsKeys {
    static let aspectRatio = "aspectRatio"
    static let textToSpeechVoiceIdentifier = "textToSpeechVoiceIdentifier"
    static let imageScale = "imageScale"
    static let showConfetti = "showConfetti"
    static let showChartTab = "showChartTab"
    static let highlighterPalette = "highlighterPalette"
    static let showProgress = "showProgress"
}
