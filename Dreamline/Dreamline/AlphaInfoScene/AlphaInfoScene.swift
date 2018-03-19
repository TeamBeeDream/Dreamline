//
//  AlphaInfoScene.swift
//  Dreamline
//
//  Created by BeeDream on 3/16/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class AlphaInfoScene: CustomScene {
    
    override func onInit() {
        self.backgroundColor = SKColor.darkGray
        
        self.addText(text: "Welcome to the Dreamline Alpha", line: 0)
        
        self.addText(text: "Please keep in mind that the graphics", line: 2)
        self.addText(text: "and audio are temporary, they will", line: 3)
        self.addText(text: "be improved in later updates", line: 4)
        
        self.addText(text: "To play, tap the left side", line: 6)
        self.addText(text: "of the screen to move left", line: 7)
        self.addText(text: "Tap right to move right", line: 8)
        
        self.addText(text: "Tap to continue", line: 12)
    }
    
    private func addText(text: String, line: Int) {
        let topMargin = self.frame.height * 0.1
        let lineOffset = CGFloat(line) * (26.0)
        
        let label = SKLabelNode(text: text)
        label.fontSize = 20.0
        label.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - topMargin - lineOffset)
        self.addChild(label)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.manager.transitionToStartScene()
        self.isPaused = true
    }
}
