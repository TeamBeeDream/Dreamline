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
    private var playerNode: SKNode! // @TODO: Make custom player node class
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
        let airplane = SKSpriteNode(imageNamed: "PaperAirplaneA")
        airplane.zPosition = 2 // @HARDCODED
        airplane.size = CGSize(width: width, height: width)
        self.scene.addChild(airplane)
        self.playerNode = airplane
    }
    
    func observe(event: KernelEvent) {
        switch event {
        case .positionUpdate(let distanceFromOrigin):
            let pos = self.playerPoint(offset: distanceFromOrigin)
            self.playerNode?.position = pos
        case .healthInvincibleUpdate(let invincible):
            self.playerNode?.alpha = invincible ? 0.5 : 1
        case .multiple(let events):
            for bundledEvent in events {
                self.observe(event: bundledEvent)
            }
        default: break
        }
    }
    
    // MARK: Private Properties
    
    private func playerPoint(offset: Double) -> CGPoint {
        let midX = self.scene.frame.midX
        let midY = self.scene.frame.midY
        let horizontalOffset = self.scene.frame.width / 3.0
        let verticalOffset = self.scene.frame.height * -0.5
        
        let x = midX + CGFloat(offset) * horizontalOffset
        let y = midY + CGFloat(yPos) * verticalOffset
        return CGPoint(x: x, y: y)
    }
}
