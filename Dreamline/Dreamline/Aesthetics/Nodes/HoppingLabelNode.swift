//
//  HoppingLabel.swift
//  Dreamline
//
//  Created by BeeDream on 5/2/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class HoppingLabelNode: SKNode {
    
    static func make(text: String,
                     font: String,
                     width: CGFloat,
                     color: UIColor) -> HoppingLabelNode {
        let instance = HoppingLabelNode()
        instance.addText(text: text,
                         font: font,
                         width: width,
                         color: color)
        return instance
    }
    
    private func addText(text: String,
                         font: String,
                         width: CGFloat,
                         color: UIColor) {
        let layout = Layout.autoLayout(fullLength: width, segments: text.count)
        for (i, char) in text.enumerated() {
            let charLabel = SKLabelNode(text: "\(char)")
            charLabel.fontSize = layout.sublength * 0.8
            charLabel.fontColor = color
            charLabel.fontName = font
            charLabel.horizontalAlignmentMode = .center
            charLabel.position = CGPoint(x: layout.positions[i] - width / 2.0, y: 0)
            charLabel.run(SKAction.sequence([SKAction.wait(forDuration: Double(i) * 0.125),
                                             self.hopAction()]))
            self.addChild(charLabel)
        }
    }
    
    private func hopAction() -> SKAction {
        var actions = [SKAction]()
        actions.append(contentsOf: self.hop(height: 15.0, duration: 0.15))
        actions.append(contentsOf: self.hop(height:  5.0, duration: 0.10))
        actions.append(SKAction.wait(forDuration: 1.0))
        return SKAction.repeatForever(SKAction.sequence(actions))
    }
    
    private func hop(height: CGFloat, duration: Double) -> [SKAction] {
        let hopUp = SKAction.moveBy(x: 0.0, y: height, duration: duration)
        let hopDown = SKAction.moveBy(x: 0.0, y: -height, duration: duration)
        hopUp.timingMode = .easeOut
        hopDown.timingMode = .easeIn
        return [hopUp, hopDown]
    }
}
