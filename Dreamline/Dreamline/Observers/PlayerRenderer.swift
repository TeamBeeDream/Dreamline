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
        
        return instance
    }
    
    // MARK: Observer Methods
    
    func observe(events: [KernelEvent]) {
        for event in events {
            switch event {
                
            case .positionUpdated(let position):
                playerNode.position = CGPoint(x: self.view.frame.midX + CGFloat(position.offset) * self.view.frame.width / 3.0,
                                              y: self.view.frame.midY - self.view.frame.height * 0.3) // @HARDCODED
                
            default: break
                
            }
        }
    }
}
