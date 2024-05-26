//
//  Card+ex.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 14/03/2024.
//

import SwiftUI

extension Card {
    var convertedPhraseToRemember: AttributedString {
        AttributedString(phraseToRemember)
    }
    
    var convertedTranslation: AttributedString? {
        guard let translation = translation, !translation.string.isEmpty else { return nil }
        
        return AttributedString(translation)
    }
    
    var formattedTranscription: String? {
        guard let transcription = transcription, !transcription.isEmpty else { return nil }
        
        return "[" + transcription + "]"
    }
    
    var convertedImage: Image? {
        guard
            let imageData = image,
            let uiImage = UIImage(data: imageData)
        else { return nil }
        
        return Image(uiImage: uiImage)
    }
    
    var needSetNewStatus: Bool {
        needMoveToThisWeek || needMoveToThisMonth || needMoveToArchive
    }
    
    var getNewStatus: Status {
        if needMoveToThisWeek {
            return .thisWeek
        } else if needMoveToThisMonth {
            return .thisMonth
        } else if needMoveToArchive {
            return .archive
        }
        
        return status
    }
}
