//
//  MockData.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 06/05/2024.
//

import SwiftUI

struct MockData {
    static let cards: [DummyItem] = [
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
