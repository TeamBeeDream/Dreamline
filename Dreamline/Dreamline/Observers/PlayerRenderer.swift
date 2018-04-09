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
    private var playerNode: SKNode!
    private var staminaNode: SKLabelNode!
    
    private var yPos: Double = 0.0
    
    // MARK: Init
    
    // @NOTE: View is probably not best thing to send as a SK container,
    // should probably just send the scene(?)
    static func make() -> PlayerRenderer {
        let instance = PlayerRenderer()
        return instance
    }
    
    // MARK: Observer Methods
    
    func setup(state: KernelState, scene: SKScene) {
        self.scene = scene
        self.yPos = state.boardState.layout.playerPosition
        
        let node = SKShapeNode(circleOfRadius: 15.0)
        node.zPosition = 2
        node.lineWidth = 0.0
        node.fillColor = .orange
        self.scene.addChild(node) // @FIXME
        self.playerNode = node
        
        let label = SKLabelNode(text: "\(state.staminaState.level)")
        label.zPosition = 2
        label.fontColor = .white
        self.scene.addChild(label) // @FIXME
        self.staminaNode = label
    }
    
    func observe(events: [KernelEvent]) {
        for event in events {
            switch event {
                
            case .positionUpdated(let position):
                let pos = self.playerPoint(offset: position.offset)
                self.playerNode?.position = pos
                self.staminaNode?.position = CGPoint(x: pos.x + 35.0, y: pos.y + 8.0)
                
            case .staminaUpdated(let level):
                self.staminaNode?.text = "\(level)"
                
            default: break
                
            }
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
