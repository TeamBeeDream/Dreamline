//
//  SKActions.swift
//  Dreamline
//
//  Created by BeeDream on 5/1/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class Actions {
    static func fadeIn(duration: Double) -> SKAction {
        return SKAction.fadeIn(withDuration: duration)
    }
    
    static func fadeOut(duration: Double) -> SKAction {
        return SKAction.fadeOut(withDuration: duration)
    }
    
    static func fadeLoop(duration: Double) -> SKAction {
        let t = duration / 2.0
        let a = SKAction.fadeAlpha(to: 0.5, duration: t)
        a.timingMode = .easeInEaseOut
        let b = SKAction.fadeAlpha(to: 1.0, duration: t)
        b.timingMode = .easeInEaseOut
        
        return SKAction.repeatForever(SKAction.sequence([a, b]))
    }
    
    static func blink(duration: Double, count: Int) -> SKAction {
        let blink = SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.0),
            SKAction.fadeIn(withDuration: duration)])
        return SKAction.repeat(blink, count: count)
    }
    
    static func blink(duration: Double) -> SKAction {
        let blink = SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.0),
            SKAction.fadeIn(withDuration: duration)])
        return SKAction.repeatForever(blink)
    }
    
    static func tint(color: UIColor, at: Double, duration: Double) -> SKAction {
        return SKAction.colorize(with: color, colorBlendFactor: CGFloat(at), duration: duration)
    }
    
    static func blinkWhite(duration: Double) -> SKAction {
        let firstPart = duration * 0.33
        let secondPart = duration * 0.66
        return SKAction.sequence([
            self.tint(color: .white, at: 1.0, duration: firstPart),
            self.tint(color: .white, at: 0.0, duration: secondPart)])
    }
    
    static func pulse(duration: Double) -> SKAction {
        return SKAction.repeatForever(SKAction.sequence([
            SKAction.scale(to: 0.7, duration: duration * 0.8),
            SKAction.scale(to: 1.0, duration: duration * 0.2)]))
    }
    
    static func hop(height: CGFloat, duration: Double) -> SKAction {
        let hopUp = SKAction.moveBy(x: 0.0, y: height, duration: duration)
        let hopDown = SKAction.moveBy(x: 0.0, y: -height, duration: duration)
        hopUp.timingMode = .easeOut
        hopDown.timingMode = .easeIn
        return SKAction.sequence([hopUp, hopDown])
    }
}
