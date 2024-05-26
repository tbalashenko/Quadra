//
//  ParticleScene.swift
//  Quadra
//
//  Created by Tatyana Balashenko on 10/04/2024.
//

import Foundation
import SpriteKit

class ParticleScene: SKScene {
    let emitter = SKEmitterNode(fileNamed: "Confetti")
    let emitter1 = SKEmitterNode(fileNamed: "Spirals")
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = .clear
        
        if let emitter = emitter {
            emitter.particleColorSequence = nil
            emitter.position.y += size.height
            emitter.position.x += size.width
            emitter.particleColorBlendFactor = 1
            emitter.particleColorRedRange = 255
            emitter.particleColorGreenRange = 255
            emitter.particleColorBlueRange = 255
            addChild(emitter)
        }
        if let emitter1 = emitter1 {
            emitter1.particleColorSequence = nil
            emitter1.position.y += size.height
            emitter1.position.x += size.width
            emitter1.particleColorBlendFactor = 1
            emitter1.particleColorRedRange = 255
            emitter1.particleColorGreenRange = 255
            emitter1.particleColorBlueRange = 255
            addChild(emitter1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
