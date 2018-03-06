//
//  GameScene.swift
//  Dreamline
//
//  Created by BeeDream on 3/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // TEMP
    var previousTime: TimeInterval = 0
    let tmpPlayerNode: SKNode = SKNode()
    let tmpVertPos: CGFloat = 0.5
    let model: GameModel = DebugGameModel()
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.cyan
        
        let playerGraphic = SKShapeNode(circleOfRadius: 16)
        playerGraphic.lineWidth = 0
        playerGraphic.fillColor = SKColor.red
        self.tmpPlayerNode.addChild(playerGraphic)
        addChild(self.tmpPlayerNode)
        self.tmpPlayerNode.position = CGPoint(x: self.frame.midX, y: self.frame.maxX * self.tmpVertPos)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let position = t.location(in: self.view)
            if position.x < self.frame.midX {
                self.model.addInput(Lane.left.rawValue)
            } else {
                self.model.addInput(Lane.right.rawValue)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.model.removeInput(count: touches.count) // woah
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.model.removeInput(count: touches.count) // woah
    }
    
    override func update(_ currentTime: TimeInterval) {
        var dt = currentTime - self.previousTime
        self.previousTime = currentTime
        if dt > 1.0 { dt = 1.0/60.0 }
        
        self.model.update(dt: dt)
        
        let position = self.model.getPosition()
        let laneWidth = self.frame.maxX / 5.0
        let offset = CGFloat(position.offset)
        self.tmpPlayerNode.position.x = self.frame.midX + (offset * laneWidth)
    }
}
