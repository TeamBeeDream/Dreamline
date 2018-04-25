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
    private var menuNode: SKNode!
    
    // MARK: Init
    
    static func make(scene: SKScene) -> PauseRenderer {
        let instance = PauseRenderer()
        instance.scene = scene
        return instance
    }
    
    // MARK: Observer Methods
    
    func sync(state: KernelState) {
        
        let container = SKNode()
        container.zPosition = 100 // @HARDCODED
        
        let background = SKShapeNode(rect: self.getMenuRect(margin: 0.1))
        background.lineWidth = 0.0
        background.fillColor = .cyan
        container.addChild(background)
        
        self.menuNode = container
        self.scene.addChild(container)
        
        //
        if !state.timeState.paused {
            container.alpha = 0.0
            container.xScale = 0.0
        }
    }
    
    func observe(events: [KernelEvent]) {
        for event in events {
            switch event {
            case .paused:
                self.menuNode.run(self.showAction())
            case .unpaused:
                self.menuNode.run(self.hideAction())
            default: break
            }
        }
    }
    
    // MARK: Private Methods
    
    private func getMenuRect(margin: CGFloat) -> CGRect {
        let frame = self.scene.frame
        let marginInPixels = frame.width * margin
        
        return CGRect(x: frame.minX + marginInPixels,
                      y: frame.minY + marginInPixels,
                      width: frame.width - marginInPixels * 2,
                      height: frame.height - marginInPixels * 2)
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
