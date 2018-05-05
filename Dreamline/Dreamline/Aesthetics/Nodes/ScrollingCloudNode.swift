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
    private var moveTime: CGPoint!
    
    static func make(texture: SKTexture,
                     size: CGFloat,
                     bounds: CGRect,
                     moveTime: CGPoint,
                     color: UIColor,
                     blendFactor: CGFloat) -> ScrollingCloudNode {
        let instance = ScrollingCloudNode()
        instance.bounds = bounds
        instance.moveTime = moveTime
        instance.addSprite(texture: texture,
                           size: size,
                           bounds: bounds,
                           position: instance.randomPoint(in: bounds),
                           color: color,
                           blendFactor: blendFactor)
        instance.addAction()
        return instance
    }
    
    private func addSprite(texture: SKTexture,
                           size: CGFloat,
                           bounds: CGRect,
                           position: CGPoint,
                           color: UIColor,
                           blendFactor: CGFloat) {
        let sprite = SKSpriteNode(texture: texture, size: CGSize(width: size, height: size))
        sprite.position = position
        self.sprite = sprite
        self.sprite.colorBlendFactor = blendFactor
        self.sprite.color = color
        self.addChild(self.sprite)
    }
    
    private func addAction() {
  
        let size = sprite.size.width * 0.75
        let minDestination = CGPoint(x: bounds.minX - size,
                                     y: bounds.minY - size)
        let maxDestination = CGPoint(x: bounds.maxX + size,
                                     y: bounds.maxY + size)
        let totalDistance = CGPoint(x: maxDestination.x - minDestination.x,
                                    y: maxDestination.y - minDestination.y)
        let partialTime = CGPoint(x: ((self.sprite.position.x - minDestination.x) / totalDistance.x) * self.moveTime.x,
                                  y: ((self.sprite.position.y - minDestination.y) / totalDistance.y) * self.moveTime.y)
        
        if self.moveTime.x > 0.1 {
            let initialActionX = SKAction.moveTo(x: minDestination.x, duration: Double(partialTime.x))
            let repeatActionX = SKAction.repeatForever(SKAction.sequence([
                SKAction.moveTo(x: maxDestination.x, duration: 0.0),
                SKAction.moveTo(x: minDestination.x, duration: Double(self.moveTime.x))]))
            self.sprite.run(SKAction.sequence([initialActionX, repeatActionX]))
        }
        
        if self.moveTime.y > 0.1 {
            let initialActionY = SKAction.moveTo(y: minDestination.y, duration: Double(partialTime.y))
            let repeatActionY = SKAction.repeatForever(SKAction.sequence([
                SKAction.moveTo(y: maxDestination.y, duration: 0.0),
                SKAction.moveTo(y: minDestination.y, duration: Double(self.moveTime.y))]))
            self.sprite.run(SKAction.sequence([initialActionY, repeatActionY]))
        }
    }
    
    private func randomPoint(in bounds: CGRect) -> CGPoint {
        let random = RealRandom()
        return CGPoint(
            x: lerp(CGFloat(random.next()), min: bounds.minX, max: bounds.maxX),
            y: lerp(CGFloat(random.next()), min: bounds.minY, max: bounds.maxY))
    }
}

class ScrollingCloudClusterNode: SKNode {
    
    static func make(count: Int, bounds: CGRect, vertical: Bool) -> ScrollingCloudClusterNode {
        let instance = ScrollingCloudClusterNode()
        for cloud in instance.generate(count: count, bounds: bounds, vertical: vertical) {
            instance.addChild(cloud)
        }
        return instance
    }
    
    private func generate(count: Int, bounds: CGRect, vertical: Bool) -> [ScrollingCloudNode] {
        let clouds: [Texture] = [.cloudA, .cloudB, .cloudC, .cloudD, .cloudE]
        var nodes = [ScrollingCloudNode]()
        for i in 0...count-1 {
            let texture = Resources.shared.getTexture(clouds[i % clouds.count])
            let t = CGFloat(i) / CGFloat(count)
            let size = lerp(t, min: bounds.width * 0.65, max: bounds.width * 0.1)
            let zPosition = lerp(t, min: 3, max: 2)
            let moveTime = lerp(t, min: 15.0, max: 20.0) // @TODO: faster for vertical
            let time = CGPoint(x: vertical ? 0.0 : moveTime,
                               y: vertical ? moveTime: 0.0)
            let blend = lerp(t, min: 0.0, max: 0.5)
            
            let cloud = ScrollingCloudNode.make(texture: texture,
                                                size: size,
                                                bounds: bounds,
                                                moveTime: time,
                                                color: UIColor(red: 154.0/255.0,
                                                               green: 227.0/255.0,
                                                               blue: 239.0/255.0,
                                                               alpha: 1.0),
                                                blendFactor: blend)
            cloud.zPosition = zPosition
            nodes.append(cloud)
        }
        return nodes
    }
}
