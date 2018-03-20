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
        self.backgroundColor = SKColor(red: 244.0/255.0, green: 152.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        
        self.display([
            "Welcome to the Dreamline Beta",
            "",
            "This is the bare-bones demo",
            "of our upcoming game.",
            "",
            "This version of the game only",
            "includes the bare mechanics,",
            "the graphics will be improved",
            "in later versions.",
            "",
            "",
            "Tap to continue"
        ])
        
        /*
        self.addText(text: "Welcome to the Dreamline Alpha", line: 0)
        
        self.addText(text: "Please keep in mind that the graphics", line: 2)
        self.addText(text: "and audio are temporary, they will", line: 3)
        self.addText(text: "be improved in later updates", line: 4)
        
        self.addText(text: "To play, tap the left side", line: 6)
        self.addText(text: "of the screen to move left", line: 7)
        self.addText(text: "Tap right to move right", line: 8)
        
        self.addText(text: "Tap to continue", line: 12)
 */
    }
    
    private func display(_ lines: [String]) {
        for (i, line) in lines.enumerated() {
            self.addText(text: line, line: i)
        }
    }
    
    private func addText(text: String, line: Int) {
        let topMargin = self.frame.height * 0.1
        let lineOffset = CGFloat(line) * (26.0)
        
        let label = SKLabelNode(text: text)
        label.fontSize = 20.0
        label.fontColor = SKColor.darkText
        label.alpha = 0.8
        label.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - topMargin - lineOffset)
        self.addChild(label)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.manager.transitionToStartScene()
        self.isPaused = true
    }
}
