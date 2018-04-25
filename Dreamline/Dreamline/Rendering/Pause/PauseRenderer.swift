//
//  PauseRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 4/25/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

// @MOVE
protocol TouchEnabled {
    func setDelegate(_ delegate: GameDelegate)
}

class PauseRenderer: Observer, TouchEnabled {
    
    // MARK: Private Properties
    
    private var scene: SKScene!
    private var menuNode: PauseMenuNode!
    private var pauseButton: ButtonNode!
    
    // MARK: Init
    
    static func make(scene: SKScene) -> PauseRenderer {
        
        // @TEMP
        let frame = scene.frame
        
        let pauseButton = PauseButtonNode.make(size: CGSize(width: 50, height: 50))
        pauseButton.position = CGPoint(x: frame.minX + 75, y: frame.maxY - 75)
        scene.addChild(pauseButton)
        
        let menuRect = PauseRenderer.getMenuRect(frame: scene.frame, margin: 0.15)
        let menuNode = PauseMenuNode.make(rect: menuRect)
        scene.addChild(menuNode)
        
        let instance = PauseRenderer()
        instance.scene = scene
        instance.pauseButton = pauseButton
        instance.menuNode = menuNode
        return instance
    }
    
    // MARK: Observer Methods
    
    func sync(state: KernelState) {
        if !state.timeState.paused {
            self.menuNode.alpha = 0.0
            self.menuNode.xScale = 0.0
        }
    }
    
    func observe(events: [KernelEvent]) {
        for event in events {
            switch event {
            case .paused:
                self.run(self.menuNode, action: self.showAction())
                self.run(self.pauseButton, action: self.hideAction())
            case .unpaused:
                self.run(self.menuNode, action: self.hideAction())
                self.run(self.pauseButton, action: self.showAction())
            case .phaseChanged(let phase):
                if phase == .setup { self.run(self.pauseButton, action: self.showAction()) }
                if phase == .results { self.run(self.pauseButton, action: self.hideAction()) }
            default: break
            }
        }
    }
    
    // MARK: TouchEnabled Methods
    
    func setDelegate(_ delegate: GameDelegate) {
        self.pauseButton.action = { delegate.pause() }
        self.menuNode.resumeButton.action = { delegate.unpause() }
        self.menuNode.menuButton.action = { delegate.gotoMenu() }
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

