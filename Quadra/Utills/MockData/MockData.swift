//
//  MockData.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 06/05/2024.
//

import SwiftUI

struct MockData {
    static var cards: [Card] {
        let context = DataController.shared.container.viewContext
        
        return [
            Card(context: context, additionTime: Date(), cardStatus: 3, phraseToRemember: NSAttributedString("That sounds really fun, but I'm not sure if I can.")),
            Card(context: context, additionTime: Date(), cardStatus: 0, phraseToRemember: NSAttributedString("Do you feel like coming along?")),
            Card(context: context, additionTime: Date(), cardStatus: 0, phraseToRemember: NSAttributedString("Under no circumstances!")),
            Card(context: context, additionTime: Date(), cardStatus: 0, phraseToRemember: NSAttributedString("That's not how I see it.")),
            Card(context: context, additionTime: Date(), cardStatus: 0, phraseToRemember: NSAttributedString("It's out of the question.")),
            Card(context: context, additionTime: Date(), cardStatus: 0, phraseToRemember: NSAttributedString("We're all on first name basis here.")),
            Card(context: context, additionTime: Date(), cardStatus: 0, phraseToRemember: NSAttributedString("on second thought")),
            Card(context: context, additionTime: Date(), cardStatus: 0, phraseToRemember: NSAttributedString("Just what the doctor ordered.")),
            Card(context: context, additionTime: Date(), cardStatus: 0, phraseToRemember: NSAttributedString("Things are not what they are thought about")),
            Card(context: context, additionTime: Date(), cardStatus: 0, phraseToRemember: NSAttributedString("It was just a matter of time."))
        ]
    }
    
    static let mockedCards: [DummyItem] = [
        DummyItem(title: "Hello, world", image: Image("hello-world")),
        DummyItem(title: "Let's call it a day", image: Image("lets-call-it-a-day")),
        DummyItem(title: "Take your time", image: Image("take-your-time")),
        DummyItem(title: "Oh, never mind", image: Image("oh-never-mind")),
        DummyItem(title: "That sounds great", image: Image("that-sounds-great"))
    ]

    static let tagCloudItems: [TagCloudItem] = [
        TagCloudItem(
            isSelected: true,
            id: UUID(),
            title: "Test",
            color: Color.green.toHex()),
        TagCloudItem(
            isSelected: true,
            id: UUID(),
            title: "Testhfiuewhfiueh",
            color: Color.green.toHex()),
        TagCloudItem(
            isSelected: true,
            id: UUID(),
            title: "Testofjeiuhfj",
            color: Color.green.toHex()),
        TagCloudItem(
            isSelected: true,
            id: UUID(),
            title: "Testojhuhhuuuuuu",
            color: Color.green.toHex()),
        TagCloudItem(
            isSelected: true,
            id: UUID(),
            title: "Testoheuiwhfiuehf",
            color: Color.green.toHex())
    ]
}
