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
        backgroundColor = SKColor.red
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.run {
                self.manager.moveToGameScene()
            }]))
    }
}
