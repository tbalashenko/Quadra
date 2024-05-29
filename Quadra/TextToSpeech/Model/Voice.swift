//
//  Voice.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 03/04/2024.
//

import Foundation

struct Voice {
    var id: UUID = UUID()
    var code: String
    var language: String
    var name: String
    var identifier: String
    var samplePhrase: String
    
    init(
        code: String,
        language: String,
        name: String,
        identifier: String,
        samplePhrase: String
    ) {
        self.code = code
        self.language = language
        self.name = name
        self.identifier = identifier
        self.samplePhrase = samplePhrase
    }
    
    init(identifier: String) {
        if let voice = Voice.voiceDictionary[identifier] {
            self = voice
        } else {
            self = .englishUs0
        }
    }
}

extension Voice {
    static let allVoices: [Voice] = [
        .chech,
        .danish,
        .greek,
        .german0,
        .german1,
        .german2,
        .englishAu0,
        .englishAu1,
        .englishAu2,
        .englishGb0,
        .englishGb1,
        .englishGb2,
        .englishIr,
        .englishUs0,
        .englishUs1,
        .englishUs2,
        .englishUs3,
        .spanishSp,
        .spanishMx,
        .finnish,
        .frenchCa,
        .frenchFr0,
        .frenchFr1,
        .frenchFr2,
        .hebrew,
        .hindi,
        .hungarian,
        .indonesian,
        .italian,
        .japanese0,
        .japanese1,
        .japanese2,
        .korean,
        .dutchBe,
        .dutchNl,
        .norwegian,
        .polish,
        .portugueseBr,
        .portuguesePt,
        .romanian,
        .russian,
        .slovak,
        .swedish,
        .thai,
        .turkish,
        .chineseCn0,
        .chineseCn1,
        .chineseCn2,
        .chineseHk,
        .chineseTw
    ]
    
    static let voiceDictionary: [String: Voice] = Dictionary(uniqueKeysWithValues: allVoices.map { ($0.identifier, $0) })
}

extension Voice {
    static let chech = Voice(code: "cs-CZ", language: "Chech", name: "Zuzana", identifier: "com.apple.ttsbundle.Zuzana-compact", samplePhrase: "Ahoj, Světe!")
    static let danish = Voice(code: "da-DK", language: "Danish", name: "Sara", identifier: "com.apple.ttsbundle.Sara-compact", samplePhrase: "Hej, Verden!")
    static let greek = Voice(code: "el-GR", language: "Greek", name: "Melina", identifier: "com.apple.ttsbundle.Melina-compact", samplePhrase: "Γεια σου, κόσμε!")
    
    static let german0 = Voice(code: "de-DE", language: "German", name: "Anna", identifier: "com.apple.ttsbundle.Anna-compact", samplePhrase: "Hallo, Welt!")
    static let german1 = Voice(code: "de-DE", language: "German", name: "Helena", identifier: "com.apple.ttsbundle.siri_female_de-DE_compact", samplePhrase: "Hallo, Welt!")
    static let german2 = Voice(code: "de-DE", language: "German", name: "Martin", identifier: "com.apple.ttsbundle.siri_male_de-DE_compact", samplePhrase: "Hallo, Welt!")
    
    static let englishAu0 = Voice(code: "en-AU", language: "English (Australia)", name: "Catherine", identifier: "com.apple.ttsbundle.siri_female_en-AU_compact", samplePhrase: "Hello, World!")
    static let englishAu1 = Voice(code: "en-AU", language: "English (Australia)", name: "Gordon", identifier: "com.apple.ttsbundle.siri_male_en-AU_compact", samplePhrase: "Hello, World!")
    static let englishAu2 = Voice(code: "en-AU", language: "English (Australia)", name: "Karen", identifier: "com.apple.ttsbundle.Karen-compact", samplePhrase: "Hello, World!")
    
    static let englishGb0 = Voice(code: "en-GB", language: "English (UK)", name: "Arthur", identifier: "com.apple.ttsbundle.siri_male_en-GB_compact", samplePhrase: "Hello, World!")
    static let englishGb1 = Voice(code: "en-GB", language: "English (UK)", name: "Daniel", identifier: "com.apple.ttsbundle.Daniel-compact", samplePhrase: "Hello, World!")
    static let englishGb2 = Voice(code: "en-GB", language: "English (UK)", name: "Martha", identifier: "com.apple.ttsbundle.siri_female_en-GB_compact", samplePhrase: "Hello, World!")
    
    static let englishIr = Voice(code: "en-IE", language: "English (Ireland)", name: "Moira", identifier: "com.apple.ttsbundle.Moira-compact", samplePhrase: "Hello, World!")
    
    static let englishUs0 = Voice(code: "en-US", language: "English (US)", name: "Aaron", identifier: "com.apple.ttsbundle.siri_male_en-US_compact", samplePhrase: "Hello, World!")
    static let englishUs1 = Voice(code: "en-US", language: "English (US)", name: "Fred", identifier: "com.apple.speech.synthesis.voice.Fred", samplePhrase: "Hello, World!")
    static let englishUs2 = Voice(code: "en-US", language: "English (US)", name: "Nicky", identifier: "com.apple.ttsbundle.siri_female_en-US_compact", samplePhrase: "Hello, World!")
    static let englishUs3 = Voice(code: "en-US", language: "English (US)", name: "Samantha", identifier: "com.apple.ttsbundle.Samantha-compact", samplePhrase: "Hello, World!")
    
    static let spanishSp = Voice(code: "es-ES", language: "Spanish (Spain)", name: "Mónica", identifier: "com.apple.ttsbundle.Monica-compact", samplePhrase: "¡Hola, mundo!")
    static let spanishMx = Voice(code: "es-MX", language: "Spanish (Mexico)", name: "Paulina", identifier: "com.apple.ttsbundle.Paulina-compact", samplePhrase: "¡Hola, mundo!")

    static let finnish = Voice(code: "fi-FI", language: "Finnish", name: "Satu", identifier: "com.apple.ttsbundle.Satu-compact", samplePhrase: "Hei, maailma!")

    static let frenchCa = Voice(code: "fr-CA", language: "French (Canada)", name: "Amélie", identifier: "com.apple.ttsbundle.Amelie-compact", samplePhrase: "Bonjour, le monde!")
    static let frenchFr0 = Voice(code: "fr-FR", language: "French (France)", name: "Daniel", identifier: "com.apple.ttsbundle.siri_male_fr-FR_compact", samplePhrase: "Bonjour, le monde!")
    static let frenchFr1 = Voice(code: "fr-FR", language: "French (France)", name: "Marie", identifier: "com.apple.ttsbundle.siri_female_fr-FR_compact", samplePhrase: "Bonjour, le monde!")
    static let frenchFr2 = Voice(code: "fr-FR", language: "French (France)", name: "Thomas", identifier: "com.apple.ttsbundle.Thomas-compact", samplePhrase: "Bonjour, le monde!")

    static let hebrew = Voice(code: "he-IL", language: "Hebrew", name: "Carmit", identifier: "com.apple.ttsbundle.Carmit-compact", samplePhrase: "שלום, עולם!")
    static let hindi = Voice(code: "hi-IN", language: "Hindi", name: "Lekha", identifier: "com.apple.ttsbundle.Lekha-compact", samplePhrase: "नमस्ते, दुनिया!")
    static let hungarian = Voice(code: "hu-HU", language: "Hungarian", name: "Mariska", identifier: "com.apple.ttsbundle.Mariska-compact", samplePhrase: "Helló, Világ!")
    static let indonesian = Voice(code: "id-ID", language: "Indonesian", name: "Damayanti", identifier: "com.apple.ttsbundle.Damayanti-compact", samplePhrase: "Halo, Dunia!")

    static let italian = Voice(code: "it-IT", language: "Italian", name: "Alice", identifier: "com.apple.ttsbundle.Alice-compact", samplePhrase: "Ciao, Mondo!")

    static let japanese0 = Voice(code: "ja-JP", language: "Japanese", name: "Hattori", identifier: "com.apple.ttsbundle.siri_male_ja-JP_compact", samplePhrase: "こんにちは、世界!")
    static let japanese1 = Voice(code: "ja-JP", language: "Japanese", name: "Kyoko", identifier: "com.apple.ttsbundle.Kyoko-compact", samplePhrase: "こんにちは、世界!")
    static let japanese2 = Voice(code: "ja-JP", language: "Japanese", name: "O-ren", identifier: "com.apple.ttsbundle.siri_female_ja-JP_compact", samplePhrase: "こんにちは、世界!")

    static let korean = Voice(code: "ko-KR", language: "Korean", name: "Yuna", identifier: "com.apple.ttsbundle.Yuna-compact", samplePhrase: "안녕하세요, 세상!")

    static let dutchBe = Voice(code: "nl-BE", language: "Dutch (Belgium)", name: "Ellen", identifier: "com.apple.ttsbundle.Ellen-compact", samplePhrase: "Hallo, wereld!")
    static let dutchNl = Voice(code: "nl-NL", language: "Dutch (Netherlands)", name: "Xander", identifier: "com.apple.ttsbundle.Xander-compact", samplePhrase: "Hallo, wereld!")

    static let norwegian = Voice(code: "no-NO", language: "Norwegian", name: "Nora", identifier: "com.apple.ttsbundle.Nora-compact", samplePhrase: "Hei, verden!")
    static let polish = Voice(code: "pl-PL", language: "Polish", name: "Zosia", identifier: "com.apple.ttsbundle.Zosia-compact", samplePhrase: "Cześć, Świecie!")

    static let portugueseBr = Voice(code: "pt-BR", language: "Portuguese (Brazil)", name: "Luciana", identifier: "com.apple.ttsbundle.Luciana-compact", samplePhrase: "Olá, mundo!")
    static let portuguesePt = Voice(code: "pt-PT", language: "Portuguese (Portugal)", name: "Joana", identifier: "com.apple.ttsbundle.Joana-compact", samplePhrase: "Olá, mundo!")

    static let romanian = Voice(code: "ro-RO", language: "Romanian", name: "Ioana", identifier: "com.apple.ttsbundle.Ioana-compact", samplePhrase: "Salut, lume!")
    static let russian = Voice(code: "ru-RU", language: "Russian", name: "Milena", identifier: "com.apple.ttsbundle.Milena-compact", samplePhrase: "Привет, мир!")
    static let slovak = Voice(code: "sk-SK", language: "Slovak", name: "Laura", identifier: "com.apple.ttsbundle.Laura-compact", samplePhrase: "Ahoj, svet!")
    static let swedish = Voice(code: "sv-SE", language: "Swedish", name: "Alva", identifier: "com.apple.ttsbundle.Alva-compact", samplePhrase: "Hej, världen!")
    static let thai = Voice(code: "th-TH", language: "Thai", name: "Kanya", identifier: "com.apple.ttsbundle.Kanya-compact", samplePhrase: "สวัสดี, โลก!")
    static let turkish = Voice(code: "tr-TR", language: "Turkish", name: "Yelda", identifier: "com.apple.ttsbundle.Yelda-compact", samplePhrase: "Merhaba, dünya!")

    static let chineseCn0 = Voice(code: "zh-CN", language: "Chinese (China)", name: "Li-mu", identifier: "com.apple.ttsbundle.siri_male_zh-CN_compact", samplePhrase: "你好，世界!")
    static let chineseCn1 = Voice(code: "zh-CN", language: "Chinese (China)", name: "Tian-Tian", identifier: "com.apple.ttsbundle.Ting-Ting-compact", samplePhrase: "你好，世界!")
    static let chineseCn2 = Voice(code: "zh-CN", language: "Chinese (China)", name: "Yu-shu", identifier: "com.apple.ttsbundle.siri_female_zh-CN_compact", samplePhrase: "你好，世界!")
    static let chineseHk = Voice(code: "zh-HK", language: "Chinese (Hong Kong)", name: "Sin-Ji", identifier: "com.apple.ttsbundle.Sin-Ji-compact", samplePhrase: "你好，世界!")
    static let chineseTw = Voice(code: "zh-TW", language: "Chinese (Taiwan)", name: "Mei-Jia", identifier: "com.apple.ttsbundle.Mei-Jia-compact", samplePhrase: "你好，世界!")
}

//MARK: - Hashable
extension Voice: Hashable { }
