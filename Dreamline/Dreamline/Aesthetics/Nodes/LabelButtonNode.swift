//
//  ResumeButtonNode.swift
//  Dreamline
//
//  Created by BeeDream on 4/25/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class LabelButtonNode: ButtonNode {
    
    private var label: SKLabelNode!
    
    static func make(_ label: String, size: CGSize, color: UIColor) -> LabelButtonNode {
        let instance = LabelButtonNode(color: color, size: size)
        instance.addLabel(label)
        instance.zPosition = 50 // @HARDCODED
        instance.isUserInteractionEnabled = true
        return instance
    }
    
    func setLabel(_ label: String) {
        self.label.text = label
    }
    
    private func addLabel(_ text: String) {
        let label = SKLabelNode(text: text)
        label.fontColor = .darkText
        label.verticalAlignmentMode = .center
        self.addChild(label)
        self.label = label
    }
}
