//
//  StartScene.swift
//  Dreamline
//
//  Created by BeeDream on 3/12/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class StartScene: SKScene {
    
    var sceneState: Scene = .start
    var sceneManager: SceneManager
    
    init(manager: SceneManager, view: SKView) {
        self.sceneManager = manager
        super.init(size: view.frame.size)
    }
    
    // this is dumb
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.red
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.run {
                self.sceneManager.moveToGameScene()
            }]))
    }
}
