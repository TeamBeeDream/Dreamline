//
//  PlayerNode.swift
//  Dreamline
//
//  Created by BeeDream on 5/1/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class PlayerNode: SKNode {
    
    private var sprite: SKSpriteNode!
    private let blinkActionKey = "blink_action"
    
    static func make(size: CGFloat) -> PlayerNode {
        let instance = PlayerNode()
        instance.drawAirplane(size: size)
        return instance
    }
    
    func startBlinking() {
        self.sprite.run(Actions.blink(duration: 0.1), withKey: blinkActionKey)
    }
    
    func stopBlinking() {
        self.sprite.removeAction(forKey: blinkActionKey)
        self.sprite.alpha = 1.0
    }
    
    private func drawAirplane(size: CGFloat) {
        let texture = SKTexture(imageNamed: "PaperAirplaneA")
        let sprite = SKSpriteNode(texture: texture, size: CGSize(width: size, height: size))
        self.addChild(sprite)
        self.sprite = sprite
    }
}
