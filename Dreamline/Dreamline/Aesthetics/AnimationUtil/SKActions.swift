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
}
