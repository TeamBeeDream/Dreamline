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
        instance.addButtons(rect: rect)
        instance.zPosition = 100 // @HARDCODED
        return instance
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
        let color = UIColor(red: 250.0/255.0, green: 202.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        self.resumeButton = LabelButtonNode.make("Resume",
                                                size: size,
                                                color: color)
        return self.resumeButton
    }
    
    private func addMenuButton(size: CGSize) -> ButtonNode {
        let color = UIColor(red: 247.0/255.0, green: 165.0/255.0, blue: 65.0/255.0, alpha: 1.0)
        self.menuButton = LabelButtonNode.make("Menu",
                                              size: size,
                                              color: color)
        return self.menuButton
    }
    
    private func addMuteButton(size: CGSize) -> ButtonNode {
        let color = UIColor(red: 244.0/255.0, green: 93.0/255.0, blue: 76.0/255.0, alpha: 1.0)
        self.muteButton = LabelButtonNode.make("Mute",
                                              size: size,
                                              color: color)
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
