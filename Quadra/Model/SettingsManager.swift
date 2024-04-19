//
//  SettingsManager.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 09/04/2024.
//

import Foundation

final class SettingsManager: ObservableObject {
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
    
    init() { }
    
    public func save(
        voice: Voice,
        aspectRatio: AspectRatio,
        imageScale: ImageScale,
        showConfetti: Bool
    ) {
        UserDefaultsManager.saveObject(voice.identifier, forKey: UserDefaultsKeys.textToSpeechVoiceIdentifier)
        UserDefaultsManager.saveObject(aspectRatio.rawValue, forKey: UserDefaultsKeys.aspectRatio)
        UserDefaultsManager.saveObject(imageScale.rawValue, forKey: UserDefaultsKeys.imageScale)
        UserDefaultsManager.saveObject(showConfetti, forKey: UserDefaultsKeys.showConfetti)
    }
}
