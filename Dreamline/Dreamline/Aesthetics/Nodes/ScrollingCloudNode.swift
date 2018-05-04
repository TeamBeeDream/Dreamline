//
//  ScrollingCloudNode.swift
//  Dreamline
//
//  Created by BeeDream on 5/3/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class ScrollingCloudNode: SKNode {
    
    private var sprite: SKSpriteNode!
    private var bounds: CGRect!
    private var moveSpeed: CGFloat!
    
    static func make(texture: SKTexture,
                     size: CGFloat,
                     bounds: CGRect,
                     speed: CGFloat) -> ScrollingCloudNode {
        let instance = ScrollingCloudNode()
        instance.bounds = bounds
        instance.moveSpeed = speed
        instance.addSprite(texture: texture, size: size, bounds: bounds)
        instance.addAction()
        return instance
    }
    
    private func addSprite(texture: SKTexture, size: CGFloat, bounds: CGRect) {
        let sprite = SKSpriteNode(texture: texture, size: CGSize(width: size, height: size))
        sprite.position = self.randomPoint(in: bounds)
        self.sprite = sprite
        self.addChild(self.sprite)
    }
    
    private func addAction() {
        
        let minDestination = bounds.minX - (sprite.size.width * 0.75)
        let maxDestination = bounds.maxX + (sprite.size.width * 0.75)
        let totalDistance = maxDestination - minDestination
        let partialTime = ((self.sprite.position.x - minDestination) / totalDistance) * self.moveSpeed
        
        sprite.run(SKAction.sequence([
            SKAction.moveTo(x: minDestination, duration: Double(partialTime)),
            SKAction.repeatForever(SKAction.sequence([
                SKAction.moveTo(x: maxDestination, duration: 0.0),
                SKAction.moveTo(x: minDestination, duration: Double(self.moveSpeed))]))]))
    }
    
    private func randomPoint(in bounds: CGRect) -> CGPoint {
        let random = RealRandom()
        return CGPoint(
            x: lerp(CGFloat(random.next()), min: bounds.minX, max: bounds.maxX),
            y: lerp(CGFloat(random.next()), min: bounds.minY, max: bounds.maxY))
    }
}
