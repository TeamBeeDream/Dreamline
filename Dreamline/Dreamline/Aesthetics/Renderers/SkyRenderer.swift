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
    //private var skyNode: SkyNode!
    private var matteNode: SKSpriteNode!
    
    private let scrollSpeed = 0.2 // @HARDCODED
    private let skyColor = UIColor.cyan
    
    static func make(scene: SKScene) -> SkyRenderer {
        let instance = SkyRenderer()
        instance.scene = scene
        instance.addSky(rect: scene.frame)
        instance.addMatte(rect: scene.frame)
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
        default: break
        }
    }
    
    private func addSky(rect: CGRect) {
        let bg = SKSpriteNode(color: UIColor(red: 154.0/255.0,
                                             green: 227.0/255.0,
                                             blue: 239.0/255.0,
                                             alpha: 1.0), size: self.scene.frame.size)
        bg.position = CGPoint(x: self.scene.frame.midX, y: self.scene.frame.midY)
        self.scene.addChild(bg)
        let clouds = ScrollingCloudClusterNode.make(count: 8, bounds: self.scene.frame, vertical: true)
        self.scene.addChild(clouds)
    }
    
    private func addMatte(rect: CGRect) {
        let matte = SKSpriteNode(color: .black, size: rect.size)
        matte.position = CGPoint(x: rect.midX, y: rect.midY)
        matte.zPosition = 4 // @HARDCODED
        matte.alpha = 0.0
        self.scene.addChild(matte)
        self.matteNode = matte
    }
    
    private func handlePhaseUpdate(_ phase: FlowControlPhase) {
        switch phase {
        case .begin:
            self.run(self.matteNode, action: Actions.fadeOut(duration: 0.2))
        case .results:
            self.run(self.matteNode, action: Actions.fadeIn(duration: 0.5))
        default:
            break
        }
    }
    
    private func run(_ node: SKNode, action: SKAction) {
        node.removeAllActions()
        node.run(action)
    }
    
    private func handlePause(_ pause: Bool) {
        if pause {
            self.setScrollSpeed(speed: 0.0)
        } else {
            self.setScrollSpeed(speed: scrollSpeed)
        }
    }
    
    private func setScrollSpeed(speed: Double) {
        //self.skyNode.setScrollSpeed(speed: speed)
    }
    
    private func setSkyColor(color: UIColor) {
        //self.skyNode.setSkyColor(color: color)
    }
}
