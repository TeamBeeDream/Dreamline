//
//  SkyRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 5/1/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class SkyRenderer: Observer {
    
    private var scene: SKScene!
    private var skyNode: SkyNode!
    
    private let scrollSpeed = 0.2 // @HARDCODED
    private let skyColor = UIColor.cyan
    
    static func make(scene: SKScene) -> SkyRenderer {
        
        let sky = SkyNode.make(frame: scene.frame)
        scene.addChild(sky)
        
        let instance = SkyRenderer()
        instance.scene = scene
        instance.skyNode = sky
        instance.setScrollSpeed(speed: instance.scrollSpeed)
        instance.setSkyColor(color: instance.skyColor)
        return instance
    }
    
    func observe(event: KernelEvent) {
        switch event {
        case .flowControlPhaseUpdate(let phase):
            self.handlePhaseUpdate(phase)
        case .timePauseUpdate(let pause):
            self.handlePause(pause)
        case .multiple(let events):
            for e in events { self.observe(event: e) }
        default: break
        }
    }
    
    private func handlePhaseUpdate(_ phase: FlowControlPhase) {
        switch phase {
            // @TODO
        default:
            break
        }
    }
    
    private func handlePause(_ pause: Bool) {
        if pause {
            self.setScrollSpeed(speed: 0.0)
        } else {
            self.setScrollSpeed(speed: scrollSpeed)
        }
    }
    
    private func setScrollSpeed(speed: Double) {
        self.skyNode.setScrollSpeed(speed: speed)
    }
    
    private func setSkyColor(color: UIColor) {
        self.skyNode.setSkyColor(color: color)
    }
}
