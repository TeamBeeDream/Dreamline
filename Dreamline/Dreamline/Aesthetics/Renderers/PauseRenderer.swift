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
    private var delegate: EventDelegate!
    private var manager: SceneManager!
    
    private var menuNode: PauseMenuNode!
    private var pauseButton: ButtonNode!
    
    // MARK: Init
    
    static func make(scene: SKScene, delegate: EventDelegate, manager: SceneManager) -> PauseRenderer {
        let instance = PauseRenderer()
        instance.scene = scene
        instance.delegate = delegate
        instance.manager = manager
        instance.addPauseButton(frame: scene.frame)
        instance.addPauseMenu(frame: scene.frame)
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
        case .settingsMuteUpdate(let mute):
            self.menuNode.toggleMuteButton(mute: mute, delegate: self.delegate)
        default: break
        }
    }
    
    // MARK: Private Methods
    
    private func addPauseButton(frame: CGRect) {
        let safeRect = Layout.safeRect(rect: frame, margin: 0.1)
        
        let width = safeRect.width * 0.2
        let pauseButton = PauseButtonNode.make(size: width)
        pauseButton.position = CGPoint(x: safeRect.minX,
                                       y: safeRect.maxY)
        pauseButton.action = { self.delegate.addEvent(.timePauseUpdate(pause: true)) }
        scene.addChild(pauseButton)
        self.pauseButton = pauseButton
    }
    
    private func addPauseMenu(frame: CGRect) {
        let menuRect = Layout.safeRect(rect: frame, margin: 0.10)
        let menuNode = PauseMenuNode.make(rect: menuRect)
        menuNode.menuButton.action = { self.manager.gotoTitle() }
        menuNode.resumeButton.action = { self.delegate.addEvent(.timePauseUpdate(pause: false)) }
        menuNode.muteButton.action = { self.delegate.addEvent(.settingsMuteUpdate(mute: true)) }
        scene.addChild(menuNode)
        self.menuNode = menuNode
    }
    
    private func run(_ node: SKNode, action: SKAction) {
        node.removeAllActions()
        node.run(action)
    }
    
    private func showAction() -> SKAction {
        let fade = SKAction.fadeIn(withDuration: 0.1)
        let flip = SKAction.scaleY(to: 1.0, duration: 0.1)
        return SKAction.group([fade, flip])
    }
    
    private func hideAction() -> SKAction {
        let fade = SKAction.fadeOut(withDuration: 0.1)
        let flip = SKAction.scaleY(to: 0.0, duration: 0.1)
        return SKAction.group([fade, flip])
    }
}

