//
//  AlphaInfoScene.swift
//  Dreamline
//
//  Created by BeeDream on 3/16/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class BetaInfoScene: CustomScene {
    
    override func onInit() {
        self.backgroundColor = SKColor(red: 244.0/255.0, green: 152.0/255.0, blue: 156.0/255.0, alpha: 1.0)
        
        self.display([
            "Welcome to the Dreamline Beta",
            "",
            "This is the second beta for our",
            "upcoming game.",
            "",
            "All graphics and mechanics are",
            "non-final and subject to change.",
            "",
            "Tap to continue"])
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
        // @FIXME
        self.manager.transitionToStartScene()
        self.isPaused = true
    }
}
