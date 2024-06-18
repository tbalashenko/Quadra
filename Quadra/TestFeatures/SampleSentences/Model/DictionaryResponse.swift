//
//  DictionaryResponse.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 10/06/2024.
//

import Foundation

struct DictionaryResponse: Codable {
    let word: String
    let phonetic: String?
    let phonetics: [Phonetic]
    let origin: String?
    let meanings: [Meaning]
    let license: License?
    let sourceUrls: [String]
}

struct Phonetic: Codable {
    let text: String?
    let audio: String?
    let sourceUrl: String?
    let license: License?
}

struct Meaning: Codable {
    let partOfSpeech: String
    let definitions: [Definition]
}

struct Definition: Codable {
    let definition: String
    let example: String?
    let synonyms: [String]
    let antonyms: [String]
}

struct License: Codable {
    let name: String
    let url: String
}

struct ErrorMessage: Codable {
    let title: String
    let message: String
    let resolution: String
}
