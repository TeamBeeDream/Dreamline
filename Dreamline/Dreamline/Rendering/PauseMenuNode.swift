//
//  PauseMenuNode.swift
//  Dreamline
//
//  Created by BeeDream on 4/25/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class PauseMenuNode: SKNode {
    
    var resumeButton: ButtonNode!
    var menuButton: ButtonNode!
    
    static func make(rect: CGRect) -> PauseMenuNode {
        let instance = PauseMenuNode()
        instance.addBackground(rect: rect)
        instance.addResumeButton(rect: rect)
        instance.addMenuButton(rect: rect)
        instance.zPosition = 100 // @HARDCODED
        return instance
    }
    
    private func addBackground(rect: CGRect) {
        let backgroundNode = SKShapeNode(rect: rect)
        backgroundNode.lineWidth = 0
        backgroundNode.fillColor = .lightGray
        backgroundNode.alpha = 0.7
        self.addChild(backgroundNode)
    }
    
    private func addResumeButton(rect: CGRect) {
        let buttonSize = CGSize(width: rect.width, height: 100)
        let resumeButton = LabelButtonNode.make("Resume",
                                                size: buttonSize,
                                                color: .orange)
        resumeButton.position = CGPoint(x: rect.midX, y: rect.midY)
        self.addChild(resumeButton)
        self.resumeButton = resumeButton
    }
    
    private func addMenuButton(rect: CGRect) {
        let buttonSize = CGSize(width: rect.width, height: 100)
        let menuButton = LabelButtonNode.make("Menu",
                                              size: buttonSize,
                                              color: .yellow)
        menuButton.position = CGPoint(x: rect.midX, y: rect.midY - 100)
        self.addChild(menuButton)
        self.menuButton = menuButton
    }
}
