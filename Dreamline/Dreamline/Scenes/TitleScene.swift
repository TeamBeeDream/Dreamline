//
//  TitleScene.swift
//  Dreamline
//
//  Created by BeeDream on 5/2/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class TitleScene: SKScene {
    
    static func make(size: CGSize) -> TitleScene {
        let instance = TitleScene(size: size)
        return instance
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .cyan
        
        let background = SKSpriteNode(imageNamed: "TitleScreenBGA")
        background.size = CGSize(width: view.frame.height, height: view.frame.height)
        background.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        self.addChild(background)
        
        let title = HoppingLabelNode.make(text: "DREAMLINE",
                                          font: "AppleSDGothicNeo-Medium",
                                          width: view.frame.width * 0.8,
                                          color: .white)
        title.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        title.zPosition = 100
        self.addChild(title)
    }
}
