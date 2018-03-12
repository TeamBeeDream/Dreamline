//
//  StartScene.swift
//  Dreamline
//
//  Created by BeeDream on 3/12/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class StartScene: CustomScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        let text = SKLabelNode(text: "tap to play")
        text.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        text.color = SKColor.white
        self.addChild(text)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.manager.moveToGameScene()
    }
}
