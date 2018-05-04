//
//  CountdownRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 5/4/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class CountdownRenderer: Observer {
    
    private var scene: SKScene!
    private var delegate: EventDelegate!
    
    private var label: SKLabelNode!
    
    static func make(scene: SKScene, delegate: EventDelegate) -> CountdownRenderer {
        let instance = CountdownRenderer()
        instance.scene = scene
        instance.delegate = delegate
        instance.makeLabel()
        return instance
    }
    
    func observe(event: KernelEvent) {
        switch event {
        case .flowControlPhaseUpdate(let phase):
            self.handlePhase(phase: phase)
        default:
            break
        }
    }
    
    private func makeLabel() {
        let label = SKLabelNode(fontNamed: "ArialRoundedMTBold")
        label.fontSize = 36
        label.fontColor = Colors.gray
        label.position = CGPoint(x: self.scene.frame.midX, y: self.scene.frame.midY)
        label.zPosition = 200 // @HARDCODED
        self.label = label
        self.scene.addChild(self.label)
    }
    
    private func handlePhase(phase: FlowControlPhase) {
        switch phase {
        case .begin:
            self.countdown()
        case .play:
            self.label.run(Actions.fadeOut(duration: 1.0))
        default:
            break
        }
    }
    
    private func countdown() {
        self.label.removeAllActions()
        self.label.run(
            SKAction.sequence([
                // Wait for transition
                SKAction.wait(forDuration: 1.3),
                
                // "READY"
                self.pumpAction(text: "READY"),
                self.pumpAction(text: "SET"),
                self.pumpAction(text: "FLY!"),
                
                // Begin play
                SKAction.run { self.delegate.addEvent(.flowControlPhaseUpdate(phase: .play)) }
            ])
        )
    }
    
    private func pumpAction(text: String) -> SKAction {
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.1)
        scaleUp.timingMode = .easeOut
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.02)
        scaleDown.timingMode = .easeInEaseOut
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        fadeIn.timingMode = .easeOut
        
        return SKAction.sequence([
            SKAction.run {
                self.label.text = text
                self.label.alpha = 0.0
                self.label.setScale(0.0)
            },
            SKAction.group([scaleUp, fadeIn]),
            scaleDown,
            SKAction.wait(forDuration: 0.4),
        ])
    }
}
