//
//  PlayerRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 4/9/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class PlayerRenderer: Observer {
    
    // MARK: Private Properties
    
    private var scene: SKScene!
    private var player: PlayerNode!
    private var health: HealthNode!
    private var yPos: Double = 0.0
    
    // MARK: Init
    
    static func make(scene: SKScene, state: KernelState) -> PlayerRenderer {
        let instance = PlayerRenderer()
        instance.scene = scene
        instance.setup(state: state)
        return instance
    }
    
    // MARK: Observer Methods
    
    private func setup(state: KernelState) {
        self.yPos = state.board.layout.playerPosition
        
        let width = self.scene.frame.width * 0.15
        let player = PlayerNode.make(size: width)
        player.zPosition = 10 // @HARDCODED
        self.scene.addChild(player)
        self.player = player
        
        let health = HealthNode.make(maxUnits: 3, size: width * 0.3)
        health.zPosition = 10 // @HARDCODED
        self.scene.addChild(health)
        self.health = health
    }
    
    func observe(event: KernelEvent) {
        switch event {
        case .positionUpdate(let distanceFromOrigin):
            self.update(position: distanceFromOrigin)
        case .healthInvincibleUpdate(let invincible):
            self.handleInvincibleUpdate(invincible: invincible)
        case .healthHitPointUpdate(let increment):
            self.health.increment(increment)
        case .healthHitPointSet(let amount):
            self.health.set(amount)
        case .flowControlPhaseUpdate(let phase):
            self.handlePhase(phase)
        default: break
        }
    }
    
    // MARK: Private Properties
    
    private func update(position: Double) {
        let pos = self.playerPoint(offset: position)
        self.player.position = pos
        
        let t = abs(position) // [0, 1]
        
        let scaleX = lerp(t, min: 1.2, max: 0.6)
        self.player.xScale = CGFloat(scaleX)
        
        let rotation = lerp(position, min: 0.0, max: 0.2)
        self.player.zRotation = CGFloat(rotation)
        
        // health
        self.health.position = CGPoint(x: pos.x, y: pos.y)
    }
    
    private func playerPoint(offset: Double) -> CGPoint {
        let midX = self.scene.frame.midX
        let midY = self.scene.frame.midY
        let horizontalOffset = self.scene.frame.width / 3.0
        let verticalOffset = self.scene.frame.height * -0.5
        
        let x = midX + CGFloat(offset) * horizontalOffset
        let y = midY + CGFloat(yPos) * verticalOffset
        return CGPoint(x: x, y: y)
    }
    
    private func handleInvincibleUpdate(invincible: Bool) {
        if invincible {
            self.player.startBlinking()
        } else {
            self.player.stopBlinking()
        }
    }
    
    private func handlePhase(_ phase: FlowControlPhase) {
        
    }
}
