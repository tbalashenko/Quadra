//
//  SettingsManager.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 09/04/2024.
//

import Foundation

class SettingsManager: ObservableObject {
    public var voice: Voice {
        let identifier = UserDefaultsManager.stringForKey(UserDefaultsKeys.textToSpeechVoiceIdentifier) ?? Voice.englishUs0.identifier
        return Voice(identifier: identifier)
    }
    
    public var aspectRatio: AspectRatio {
        let rawValue = UserDefaultsManager.stringForKey(UserDefaultsKeys.aspectRatio) ?? AspectRatio.sixteenToNine.rawValue
        return AspectRatio(rawValue: rawValue) ?? .sixteenToNine
    }
    
    init() {
        
    }
    
    public func save(voice: Voice, aspectRatio: AspectRatio) {
        UserDefaultsManager.saveObject(voice.identifier, forKey: UserDefaultsKeys.textToSpeechVoiceIdentifier)
        UserDefaultsManager.saveObject(aspectRatio.rawValue, forKey: UserDefaultsKeys.aspectRatio)
    }
}
