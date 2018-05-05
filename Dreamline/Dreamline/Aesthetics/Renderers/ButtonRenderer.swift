//
//  ButtonRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 5/4/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class ButtonRenderer: Observer {
    
    private var scene: SKScene!
    private var leftButton: ButtonNode!
    private var rightButton: ButtonNode!
    private var buttonContainer: SKNode!
    
    private let hiAlpha: CGFloat = 0.3
    private let loAlpha: CGFloat = 0.7
    
    static func make(scene: SKScene) -> ButtonRenderer {
        let instance = ButtonRenderer()
        instance.scene = scene
        instance.setupButtons()
        return instance
    }
    
    func observe(event: KernelEvent) {
        switch event {
        case .positionTargetUpdate(let target):
            self.handleTap(target: target)
        case .flowControlPhaseUpdate(let phase):
            self.handlePhase(phase: phase)
        default:
            break
        }
    }
    
    private func setupButtons() {
        let buttonTexture = Resources.shared.getTexture(.arrowButton)
        let width = self.scene.frame.width * 0.2
        let size = CGSize(width: width, height: width)
        
        let layoutX = Layout.autoLayout(fullLength: self.scene.frame.width, segments: 2)
        let layoutY = Layout.autoLayout(fullLength: self.scene.frame.height, segments: 3)
        
        self.leftButton = self.makeButton(texture: buttonTexture, size: size, xScale: 1)
        self.leftButton.position = CGPoint(x: layoutX.positions[0], y: layoutY.positions[0])
        
        self.rightButton = self.makeButton(texture: buttonTexture, size: size, xScale: -1)
        self.rightButton.position = CGPoint(x: layoutX.positions[1], y: layoutY.positions[0])
        
        self.buttonContainer = SKNode()
        //self.buttonContainer.alpha = 0.0
        self.buttonContainer.addChild(self.leftButton)
        self.buttonContainer.addChild(self.rightButton)
        self.scene.addChild(self.buttonContainer)
    }
    
    private func makeButton(texture: SKTexture, size: CGSize, xScale: Int) -> ButtonNode {
        let button = ButtonNode(texture: texture, size: size)
        button.color = Colors.red
        button.colorBlendFactor = 0.8
        button.alpha = self.hiAlpha
        button.xScale = CGFloat(xScale)
        button.zPosition = 200 // @HARDCODED
        return button
    }
    
    private func handleTap(target: Int) {
        switch target {
        case 1:
            self.leftButton.alpha = self.hiAlpha
            self.rightButton.alpha = self.loAlpha
        case -1:
            self.leftButton.alpha = self.loAlpha
            self.rightButton.alpha = self.hiAlpha
        default:
            self.leftButton.alpha = self.hiAlpha
            self.rightButton.alpha = self.hiAlpha
        }
    }
    
    private func handlePhase(phase: FlowControlPhase) {
        switch phase {
        case .origin: fallthrough
        case .begin: fallthrough
        case .select: fallthrough
        case .results:
            self.buttonContainer.alpha = 0.0
        case .play:
            self.buttonContainer.alpha = 1.0
        }
    }
}
