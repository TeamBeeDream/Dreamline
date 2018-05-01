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
    var muteButton: LabelButtonNode!
    
    static func make(rect: CGRect) -> PauseMenuNode {
        let instance = PauseMenuNode()
        instance.addBackground(rect: rect)
        instance.addButtons(rect: rect)
//        instance.addResumeButton(rect: rect)
//        instance.addMenuButton(rect: rect)
//        instance.addMuteButton(rect: rect)
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
    
    private func addButtons(rect: CGRect) {
        let layout = Layout.autoLayout(fullLength: rect.height, segments: 3)
        let buttonSize = CGSize(width: rect.width, height: layout.sublength)
        let buttonPositions = layout.positions
        
        let buttons = [self.addResumeButton(size: buttonSize),
                       self.addMenuButton(size: buttonSize),
                       self.addMuteButton(size: buttonSize)]
        for (i, button) in buttons.enumerated() {
            let position = buttonPositions[i]
            button.position = CGPoint(x: rect.midX, y: rect.maxY - position)
            self.addChild(button)
        }
    }
    
    private func addResumeButton(size: CGSize) -> ButtonNode {
        self.resumeButton = LabelButtonNode.make("Resume",
                                                size: size,
                                                color: .orange)
        return self.resumeButton
    }
    
    private func addMenuButton(size: CGSize) -> ButtonNode {
        self.menuButton = LabelButtonNode.make("Menu",
                                              size: size,
                                              color: .yellow)
        return self.menuButton
    }
    
    private func addMuteButton(size: CGSize) -> ButtonNode {
        self.muteButton = LabelButtonNode.make("Mute",
                                              size: size,
                                              color: .green)
        return self.muteButton
    }
    
    func toggleMuteButton(mute: Bool, delegate: EventDelegate) {
        if mute {
            self.muteButton.setLabel("Unmute")
        } else {
            self.muteButton.setLabel("Mute")
        }
        self.muteButton.action = { delegate.addEvent(.settingsMuteUpdate(mute: !mute)) }
    }
}
