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
    
    private var view: SKView!       // @ROBUSTNESS
    private var playerNode: SKNode!
    private var staminaNode: SKLabelNode!
    
    // MARK: Init
    
    // @NOTE: View is probably not best thing to send as a SK container,
    // should probably just send the scene(?)
    static func make(view: SKView) -> PlayerRenderer {
        let instance = PlayerRenderer()
        instance.view = view
        
        let node = SKShapeNode(circleOfRadius: 15.0)
        node.zPosition = 2
        node.lineWidth = 0.0
        node.fillColor = .orange
        view.scene!.addChild(node) // @FIXME
        instance.playerNode = node
        
        let label = SKLabelNode(text: "")
        label.zPosition = 2
        label.fontColor = .white
        view.scene!.addChild(label) // @FIXME
        instance.staminaNode = label
        
        return instance
    }
    
    // MARK: Observer Methods
    
    func observe(events: [KernelEvent]) {
        for event in events {
            switch event {
                
            case .positionUpdated(let position):
                let viewPosition = self.playerPosition(offset: position.offset)
                self.playerNode.position = viewPosition
                self.staminaNode.position = CGPoint(x: viewPosition.x + 35.0, y: viewPosition.y + 8.0)
                
            case .staminaUpdated(let level):
                self.staminaNode.text = "\(level)"
                
            default: break
                
            }
        }
    }
    
    // MARK: Private Properties
    
    private func playerPosition(offset: Double) -> CGPoint {
        let midX = self.view.frame.midX
        let midY = self.view.frame.midY
        let horizontalOffset = self.view.frame.width / 3.0
        let verticalOffset = self.view.frame.height * -0.3
        
        return CGPoint(x: midX + CGFloat(offset) * horizontalOffset,
                       y: midY + verticalOffset)
    }
}
