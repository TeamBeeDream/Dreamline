//
//  ScoreCounter.swift
//  Dreamline
//
//  Created by BeeDream on 4/5/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

// @NOTE: This is solely responsible for controlling the behavior of the counter
class ScoreCounter: SKNode {
    
    // MARK: Private Properties
    
    private var node: ScoreCounterNode!
    
    // MARK: Init
    
    static func make(frame: CGRect) -> ScoreCounter {
        let instance = ScoreCounter()
        instance.node = ScoreCounterNode.make(container: instance, frame: frame)
        return instance
    }
    
    // MARK: Public Methods
    
    func setScore(_ value: Int) {
        self.node.setScore(value)
    }
}

// @NOTE: This is solely responsible for handling how the text is displayed via SpriteKit
class ScoreCounterNode {
    
    // MARK: Private Properties
    
    private var container: SKNode!
    private var scoreLabel: SKLabelNode!
    
    // MARK: Init
    
    static func make(container: SKNode, frame: CGRect) -> ScoreCounterNode {
        let scoreLabel = SKLabelNode(text: "0")
        scoreLabel.fontColor = .darkText
        scoreLabel.fontSize = 20.0
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 5.0)
        container.addChild(scoreLabel)
        
        let instance = ScoreCounterNode()
        instance.container = container
        instance.scoreLabel = scoreLabel
        return instance
    }
    
    // MARK: Public Methods
    
    func setScore(_ score: Int) {
        self.scoreLabel.text = "\(score)"
    }
}
