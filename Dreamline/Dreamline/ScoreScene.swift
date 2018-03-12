//
//  ScoreScene.swift
//  Dreamline
//
//  Created by BeeDream on 3/12/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class ScoreScene: CustomScene {
    
    let score: Int
    
    init(manager: SceneManager, view: SKView, score: Int) {
        self.score = score
        super.init(manager: manager, view: view)
    }
    
    // annoying
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        let scoreText = SKLabelNode(text: "you got \(self.score)")
        scoreText.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        scoreText.color = SKColor.white
        self.addChild(scoreText)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.manager.moveToStartScene()
    }
}
