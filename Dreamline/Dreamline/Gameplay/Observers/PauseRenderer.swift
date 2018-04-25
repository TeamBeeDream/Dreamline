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
    private var menuNode: SKNode!
    private var pauseButton: ButtonNode!
    private var resumeButton: ButtonNode!
    
    // MARK: Init
    
    static func make(scene: SKScene) -> PauseRenderer {
        
        // @TEMP
        let frame = scene.frame
        let buttonRect = CGRect(x: frame.minX + 50, y: frame.maxY - 50, width: 50, height: 50)
        
        let container = SKNode()
        container.zPosition = 100 // @HARDCODED
        
        let background = SKShapeNode(rect: PauseRenderer.getMenuRect(frame: scene.frame, margin: 0.1))
        background.lineWidth = 0.0
        background.fillColor = .cyan
        container.addChild(background)
        scene.addChild(container)
        
        let pauseButton = ButtonNode(color: .red, size: buttonRect.size)
        pauseButton.zPosition = 50 // :(
        pauseButton.isUserInteractionEnabled = true
        pauseButton.position = buttonRect.origin
        scene.addChild(pauseButton)
        
        let resumeButton = ButtonNode(color: .orange, size: CGSize(width: 100, height: 50))
        resumeButton.zPosition = 101
        resumeButton.isUserInteractionEnabled = true
        resumeButton.position = CGPoint(x: frame.midX, y: frame.midY)
        container.addChild(resumeButton)
        
        let instance = PauseRenderer()
        instance.scene = scene
        instance.pauseButton = pauseButton
        instance.resumeButton = resumeButton
        instance.menuNode = container
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
                self.menuNode.run(self.showAction())
            case .unpaused:
                self.menuNode.run(self.hideAction())
            default: break
            }
        }
    }
    
    // MARK: TouchEnabled Methods
    
    func setDelegate(_ delegate: GameDelegate) {
        self.pauseButton.delegate = {
            delegate.pause()
        }
        
        self.resumeButton.delegate = {
            delegate.unpause()
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

protocol TouchDelegate {
    func handleTouch()
}

class ButtonNode: SKSpriteNode {
    
    var delegate: (() -> Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?()
    }
}
