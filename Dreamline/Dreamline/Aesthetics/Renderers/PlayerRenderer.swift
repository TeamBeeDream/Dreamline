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
    private var score: SKLabelNode!
    
    private var invincible: Bool = false
    private var scoreValue: Int = 0
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
        
        self.scoreValue = 0
        let score = SKLabelNode(text: "\(self.scoreValue)")
        score.fontColor = .darkText
        score.fontSize = 24
        score.zPosition = 10 // @HARDCODED
        score.position = CGPoint(x: self.scene.frame.midX,
                                 y: self.scene.frame.maxY - self.scene.frame.height * 0.1)
        score.verticalAlignmentMode = .top
        self.scene.addChild(score)
        self.score = score
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
        case .healthBarrierUpdate(let pass):
            if pass {
                self.scoreValue += 1
                self.score.text = "\(self.scoreValue)"
            }
        default: break
        }
    }
    
    // MARK: Private Properties
    
    private func update(position: Double) {
        let pos = self.playerPoint(offset: position)
        self.player.position = pos
        
        let t = abs(position) // [0, 1]
        
        let scaleX = lerp(t, min: 1.2, max: 0.8)
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
        self.invincible = invincible
    }
    
    private func handlePhase(_ phase: FlowControlPhase) {
        switch phase {
        case .origin:
            self.scoreValue = 0
            self.score.text = "0"
            self.player.alpha = 1.0
        case .play:
            self.health.alpha = 1.0
            self.score.alpha = 1.0
        case .results:
            self.health.alpha = 0.0
            self.score.alpha = 0.0
            if self.invincible { self.player.alpha = 0.0 }
        default:
            break
        }
    }
}
