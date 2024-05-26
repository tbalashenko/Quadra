//
//  SettingsManager.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 09/04/2024.
//

import Foundation

final class SettingsManager {
    static let shared = SettingsManager()
    
    public var voice: Voice {
        let identifier = UserDefaultsManager.stringForKey(UserDefaultsKeys.textToSpeechVoiceIdentifier) ?? Voice.englishUs0.identifier
        return Voice(identifier: identifier)
    }
    
    public var aspectRatio: AspectRatio {
        let rawValue = UserDefaultsManager.stringForKey(UserDefaultsKeys.aspectRatio) ?? AspectRatio.sixteenToNine.rawValue
        return AspectRatio(rawValue: rawValue) ?? .sixteenToNine
    }
    
    public var imageScale: ImageScale {
        let rawValue = UserDefaultsManager.doubleForKey(UserDefaultsKeys.imageScale) ?? ImageScale.percent100.rawValue
        return ImageScale(rawValue: rawValue) ?? .percent100
    }
    
    public var showConfetti: Bool {
        UserDefaultsManager.boolForKey(UserDefaultsKeys.showConfetti) ?? true
    }
    
    public var highliterPalette: HighlighterPalette {
        let rawValue = UserDefaultsManager.integerForKey(UserDefaultsKeys.highlighterPalette) ?? 0
        return HighlighterPalette(rawValue: rawValue) ?? .pale
    }
    
    private init() { }
    
    public func save(
        voice: Voice,
        aspectRatio: AspectRatio,
        imageScale: ImageScale,
        showConfetti: Bool,
        highliterPalette: HighlighterPalette
    ) {
        UserDefaultsManager.saveObject(voice.identifier, forKey: UserDefaultsKeys.textToSpeechVoiceIdentifier)
        UserDefaultsManager.saveObject(aspectRatio.rawValue, forKey: UserDefaultsKeys.aspectRatio)
        UserDefaultsManager.saveObject(imageScale.rawValue, forKey: UserDefaultsKeys.imageScale)
        UserDefaultsManager.saveObject(showConfetti, forKey: UserDefaultsKeys.showConfetti)
        UserDefaultsManager.saveObject(highliterPalette.rawValue, forKey: UserDefaultsKeys.highlighterPalette)
    }
}
