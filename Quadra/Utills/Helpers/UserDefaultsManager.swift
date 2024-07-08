//
//  UserDefaultsManager.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 03/04/2024.
//

import Foundation

struct UserDefaultsManager {
    static func removeObject(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }

    static func saveObject(_ object: Any?, forKey defaultName: String) {
        UserDefaults.standard.set(object, forKey: defaultName)
        UserDefaults.standard.synchronize()
    }

    static func integerForKey(_ defaultName: String) -> Int? {
        return UserDefaults.standard.object(forKey: defaultName) as? Int
    }

    static func doubleForKey(_ defaultName: String) -> Double? {
        return UserDefaults.standard.object(forKey: defaultName) as? Double
    }

    static func boolForKey(_ defaultName: String) -> Bool? {
        return UserDefaults.standard.object(forKey: defaultName) as? Bool
    }
    
    static func dateForKey(_ defaultName: String) -> Date? {
        return UserDefaults.standard.object(forKey: defaultName) as? Date
    }

    static func stringForKey(_ defaultName: String) -> String? {
        return UserDefaults.standard.string(forKey: defaultName)
    }

    static func objectForKey(_ defaultName: String) -> AnyObject? {
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
    static let sendNotifications = "sendNotifications"
    static let reminderTime = "reminderTime"
}
