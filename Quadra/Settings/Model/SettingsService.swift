//
//  SettingsManager.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 09/04/2024.
//

import Foundation

final class SettingsService {
    static var voice: Voice {
        let identifier = UserDefaultsManager.stringForKey(UserDefaultsKeys.textToSpeechVoiceIdentifier) ?? Voice.englishUs0.identifier
        return Voice(identifier: identifier)
    }

    static var aspectRatio: AspectRatio {
        let rawValue = UserDefaultsManager.stringForKey(UserDefaultsKeys.aspectRatio) ?? AspectRatio.sixteenToNine.rawValue
        return AspectRatio(rawValue: rawValue) ?? .sixteenToNine
    }

    static var imageScale: ImageScale {
        let rawValue = UserDefaultsManager.doubleForKey(UserDefaultsKeys.imageScale) ?? ImageScale.percent100.rawValue
        return ImageScale(rawValue: rawValue) ?? .percent100
    }

    static var showConfetti: Bool {
        UserDefaultsManager.boolForKey(UserDefaultsKeys.showConfetti) ?? true
    }

    static var highliterPalette: HighlighterPalette {
        let rawValue = UserDefaultsManager.integerForKey(UserDefaultsKeys.highlighterPalette) ?? 0
        return HighlighterPalette(rawValue: rawValue) ?? .pale
    }

    static var showProgress: Bool {
        UserDefaultsManager.boolForKey(UserDefaultsKeys.showProgress) ?? true
    }
    
    static var reminderTime: Date {
        UserDefaultsManager.dateForKey(UserDefaultsKeys.reminderTime) ?? Date()
    }

    static func save(
        voice: Voice,
        aspectRatio: AspectRatio,
        imageScale: ImageScale,
        showConfetti: Bool,
        highliterPalette: HighlighterPalette,
        showProgress: Bool,
        sendNotifications: Bool
    ) {
        UserDefaultsManager.saveObject(voice.identifier, forKey: UserDefaultsKeys.textToSpeechVoiceIdentifier)
        UserDefaultsManager.saveObject(aspectRatio.rawValue, forKey: UserDefaultsKeys.aspectRatio)
        UserDefaultsManager.saveObject(imageScale.rawValue, forKey: UserDefaultsKeys.imageScale)
        UserDefaultsManager.saveObject(showConfetti, forKey: UserDefaultsKeys.showConfetti)
        UserDefaultsManager.saveObject(highliterPalette.rawValue, forKey: UserDefaultsKeys.highlighterPalette)
        UserDefaultsManager.saveObject(showProgress, forKey: UserDefaultsKeys.showProgress)
        UserDefaultsManager.saveObject(sendNotifications, forKey: UserDefaultsKeys.sendNotifications)
    }
}
