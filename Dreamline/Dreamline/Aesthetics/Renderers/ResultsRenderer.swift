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
    
    private var delegate: EventDelegate!
    
    // MARK: Init
    
    static func make(scene: SKScene, delegate: EventDelegate) -> ResultsRenderer {
        let container = SKNode()
        scene.addChild(container)
        
        let instance = ResultsRenderer()
        instance.scene = scene
        instance.nodeContainer = container
        instance.delegate = delegate
        return instance
    }
    
    // MARK: Observer Methods
    
    func observe(event: KernelEvent) {
        switch event {
            
        case .flowControlPhaseUpdate(let phase):
            if phase == .origin {
                self.nodeContainer.removeAllChildren()
            }
            
        case .roundComplete(let level):
            self.draw(level: level)
            
        default: break
        }
    }
    
    private func draw(level: Int) {
        let label = SKLabelNode(text: "ROUND \(level) COMPLETE")
        label.fontColor = .white
        label.fontSize = 26
        label.zPosition = 40 // @HARDCODED
        label.position = CGPoint(x: self.scene.frame.midX, y: self.scene.frame.midY)
        label.run(SKAction.fadeIn(withDuration: 0.2))
        self.nodeContainer.addChild(label)
        
        // @HACK
        let continueButton = ButtonNode(color: .clear, size: self.scene.frame.size)
        continueButton.isUserInteractionEnabled = true
        continueButton.zPosition = 100 // @HARDCODED
        continueButton.position = CGPoint(x: self.scene.frame.midX, y: self.scene.frame.midY)
        continueButton.action = { self.delegate.addEvent(.flowControlPhaseUpdate(phase: .origin)) }
        self.nodeContainer.addChild(continueButton)
    }
}
