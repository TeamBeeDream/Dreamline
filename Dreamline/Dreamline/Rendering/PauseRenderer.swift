//
//  PauseRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 4/25/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class PauseRenderer: Observer {
    
    // MARK: Private Properties
    
    private var scene: SKScene!
    private var menuNode: PauseMenuNode!
    private var pauseButton: ButtonNode!
    
    private var delegate: EventDelegate!
    
    // MARK: Init
    
    static func make(scene: SKScene, delegate: EventDelegate) -> PauseRenderer {
        
        // @TEMP
        let frame = scene.frame
        
        let pauseButton = PauseButtonNode.make(size: CGSize(width: 50, height: 50))
        pauseButton.position = CGPoint(x: frame.minX + 75, y: frame.maxY - 75)
        pauseButton.action = { delegate.addEvent(.timePauseUpdate(pause: true)) }
        scene.addChild(pauseButton)
        
        let menuRect = PauseRenderer.getMenuRect(frame: scene.frame, margin: 0.15)
        let menuNode = PauseMenuNode.make(rect: menuRect)
        menuNode.resumeButton.action = { delegate.addEvent(.timePauseUpdate(pause: false)) }
        //menuNode.menuButton.action = {}
        scene.addChild(menuNode)
        
        let instance = PauseRenderer()
        instance.scene = scene
        instance.pauseButton = pauseButton
        instance.menuNode = menuNode
        instance.delegate = delegate
        return instance
    }
    
    // MARK: Observer Methods
    
    func observe(event: KernelEvent) {
        switch event {
        case .timePauseUpdate(let pause):
            if pause {
                self.run(self.menuNode, action: self.showAction())
                self.run(self.pauseButton, action: self.hideAction())
            } else {
                self.run(self.menuNode, action: self.hideAction())
                self.run(self.pauseButton, action: self.showAction())
            }
        case .flowControlPhaseUpdate(let phase):
            if phase == .begin { self.run(self.pauseButton, action: self.showAction()) }
            if phase == .results { self.run(self.pauseButton, action: self.hideAction()) }
        case .multiple(let events):
            for e in events {
                self.observe(event: e)
            }
        default: break
        }
    }
    
    // MARK: Private Methods
    
    private static func getMenuRect(frame: CGRect, margin: CGFloat) -> CGRect {
        let marginInPixels = frame.width * margin
        
        return CGRect(x: frame.minX + marginInPixels,
                      y: frame.minY + marginInPixels,
                      width: frame.width - marginInPixels * 2,
                      height: frame.height - marginInPixels * 2)
    }
    
    private func run(_ node: SKNode, action: SKAction) {
        node.removeAllActions()
        node.run(action)
    }
    
    private func showAction() -> SKAction {
        let fade = SKAction.fadeIn(withDuration: 0.1)
        let flip = SKAction.scaleX(to: 1.0, duration: 0.1)
        return SKAction.group([fade, flip])
    }
    
    private func hideAction() -> SKAction {
        let fade = SKAction.fadeOut(withDuration: 0.1)
        let flip = SKAction.scaleX(to: 0.0, duration: 0.1)
        return SKAction.group([fade, flip])
    }
}
