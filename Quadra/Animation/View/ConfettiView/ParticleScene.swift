//
//  ParticleScene.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 10/04/2024.
//

import Foundation
import SpriteKit

class ParticleScene: SKScene {
    let emitters = [SKEmitterNode(fileNamed: "Confetti"), SKEmitterNode(fileNamed: "Spirals")]

    override init(size: CGSize) {
        super.init(size: size)

        backgroundColor = .clear

        for emitter in emitters {
            guard let emitter else { continue }

            emitter.particleColorSequence = nil
            emitter.position.y += size.height
            emitter.position.x += size.width
            emitter.particleColorBlendFactor = 1
            emitter.particleColorRedRange = 255
            emitter.particleColorGreenRange = 255
            emitter.particleColorBlueRange = 255
            addChild(emitter)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
