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
        
        let node = SKShapeNode(circleOfRadius: 15.0)
        node.zPosition = 2
        node.lineWidth = 0.0
        node.fillColor = .orange
        self.scene.addChild(node) // @FIXME
        self.playerNode = node
    }
    
    func observe(event: KernelEvent) {
        switch event {
        case .positionUpdate(let distanceFromOrigin):
            let pos = self.playerPoint(offset: distanceFromOrigin)
            self.playerNode?.position = pos
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
