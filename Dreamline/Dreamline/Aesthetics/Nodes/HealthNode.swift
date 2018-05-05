//
//  HealthNode.swift
//  Dreamline
//
//  Created by BeeDream on 5/4/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class HealthNode: SKNode {
    
    private var units: Int!
    private var maxUnits: Int!
    private var hearts: [SKSpriteNode]!
    
    static func make(maxUnits: Int, size: CGFloat) -> HealthNode {
        let instance = HealthNode()
        instance.maxUnits = maxUnits
        instance.units = maxUnits
        instance.setup(size: size)
        return instance
    }
    
    func increment(_ amount: Int) {
        self.units = clamp(self.units + amount, min: 0, max: self.maxUnits)
        self.recolor()
    }
    
    func set(_ amount: Int) {
        self.units = clamp(amount, min: 0, max: self.maxUnits)
        self.recolor()
    }
    
    private func setup(size: CGFloat) {
        self.hearts = [SKSpriteNode]()
        for i in 1...self.maxUnits {
            let heart = SKSpriteNode(texture: Resources.shared.getTexture(.heart),
                                     size: CGSize(width: size, height: size))
            heart.position = CGPoint(x: 0.0, y: (size * 1.25) * CGFloat(-(i+1)))
            heart.color = Colors.red
            heart.colorBlendFactor = 0.8
            heart.run(SKAction.sequence([
                SKAction.wait(forDuration: Double(i) * 0.15),
                Actions.pulse(duration: 1.3)]))
            self.addChild(heart)
            self.hearts.append(heart)
        }
        self.recolor()
    }
    
    private func recolor() {
        for i in 0...self.maxUnits-1 {
            let heart = self.hearts[i]
            heart.alpha = i < self.units ? 1.0 : 0.3
        }
    }
}
