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
    
    private var container: SKNode!
    
    static func make(rect: CGRect) -> PauseMenuNode {
        let instance = PauseMenuNode()
        instance.addButtons(rect: rect)
        instance.zPosition = 100 // @HARDCODED
        return instance
    }
    
    private func addButtons(rect: CGRect) {
        self.container = SKNode()
        
        let bg = SKSpriteNode(color: Colors.pink, size: rect.size)
        bg.position = CGPoint(x: rect.midX, y: rect.midY)
        self.container.addChild(bg)
        
        let layout = Layout.autoLayout(fullLength: rect.height, segments: 3)
        let buttonSize = CGSize(width: rect.width, height: layout.sublength - 2)
        let buttonPositions = layout.positions
        
        let buttons = [self.addResumeButton(size: buttonSize),
                       self.addMenuButton(size: buttonSize),
                       self.addMuteButton(size: buttonSize)]
        for (i, button) in buttons.enumerated() {
            let position = buttonPositions[i]
            button.position = CGPoint(x: rect.midX, y: rect.maxY - position)
            self.container.addChild(button)
        }
        
        self.addChild(self.container)
        self.container.alpha = 0.65
    }
    
    private func addResumeButton(size: CGSize) -> ButtonNode {
        self.resumeButton = LabelButtonNode.make("Resume",
                                                size: size,
                                                color: .white)
        return self.resumeButton
    }
    
    private func addMenuButton(size: CGSize) -> ButtonNode {
        self.menuButton = LabelButtonNode.make("Menu",
                                              size: size,
                                              color: .white)
        return self.menuButton
    }
    
    private func addMuteButton(size: CGSize) -> ButtonNode {
        self.muteButton = LabelButtonNode.make("Mute",
                                              size: size,
                                              color: .white)
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
