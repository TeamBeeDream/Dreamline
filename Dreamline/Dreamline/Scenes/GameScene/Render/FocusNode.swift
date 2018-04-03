//
//  FocusNode.swift
//  Dreamline
//
//  Created by BeeDream on 4/3/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class FocusNode: SKNode {
    
    // MARK: Private Properties
    
    private var level: Int!
    private var maxLevel: Int!
    
    private var dots: [SKNode]!
    private let dotRadius: CGFloat = 5.0
    private let dotOffset: CGFloat = 20.0
    private let dotColor: SKColor = .white
    private let dotAlphaOn: CGFloat = 0.9
    private let dotAlphaOff: CGFloat = 0.3
    
    // MARK: Init
    
    static func make(level: Int, maxLevel: Int) -> FocusNode {
        let node = FocusNode()
        node.level = level
        node.maxLevel = maxLevel
        node.dots = [SKNode]()
        node.setup()
        return node
    }
    
    // MARK: Public Methods
    
    func raiseLevel() {
        self.level = min(self.level + 1, self.maxLevel)
        self.updateDots()
    }
    
    func lowerLevel() {
        self.level = max(0, self.level - 1)
        self.updateDots()
    }
    
    // MARK: Private Methods
    
    private func setup() {
        // @ROBUSTNESS: self.level and self.maxLevel must be set before calling this method
        
        for i in 0...self.maxLevel-1 {
            let dot = self.createDot()
            dot.position = CGPoint(x: self.dotOffset * CGFloat(i), y: 0.0)
            self.addChild(dot)
            self.dots.append(dot)
        }
        
        self.updateDots()
    }
    
    private func createDot() -> SKNode {
        // @HARDCODED
        let dot = SKShapeNode(circleOfRadius: self.dotRadius)
        dot.strokeColor = .clear
        dot.fillColor = self.dotColor
        return dot
    }
    
    private func updateDots() {
        for (i, dot) in self.dots.enumerated() {
            dot.alpha = i >= self.level ? self.dotAlphaOff : self.dotAlphaOn
        }
    }
}
