//
//  ResultsRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 4/24/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class ResultsRenderer: Observer {
    
    // MARK: Private Properties
    
    private var scene: SKScene!
    private var nodeContainer: SKNode!
    
    // MARK: Init
    
    static func make(scene: SKScene) -> ResultsRenderer {
        let container = SKNode()
        scene.addChild(container)
        
        let instance = ResultsRenderer()
        instance.scene = scene
        instance.nodeContainer = container
        return instance
    }
    
    // MARK: Observer Methods
    
    func sync(state: KernelState) {}
    
    func observe(events: [KernelEvent]) {
        for event in events {
            switch event {
            case .roundComplete(let score):
                let label = SKLabelNode(text: "ROUND COMPLETE")
                label.fontColor = .white
                label.fontSize = 30
                label.position = CGPoint(x: self.scene.frame.midX, y: self.scene.frame.midY)
                label.run(SKAction.fadeIn(withDuration: 0.2))
                self.nodeContainer.addChild(label)
                
                let scoreLabel = SKLabelNode(text: "\(score.barriersPassed)")
                scoreLabel.fontColor = .lightText
                scoreLabel.fontSize = 18
                scoreLabel.position = label.position
                scoreLabel.position.y -= 24
                self.nodeContainer.addChild(scoreLabel)
                
            default: break
            }
        }
    }
}
