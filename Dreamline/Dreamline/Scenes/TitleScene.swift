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
        title.position = CGPoint(x: view.frame.midX, y: view.frame.midY + view.frame.height * 0.2)
        title.zPosition = 100
        self.addChild(title)
        
        let titleShadow = HoppingLabelNode.make(text: "DREAMLINE",
                                          font: "AppleSDGothicNeo-Medium",
                                          width: view.frame.width * 0.8,
                                          color: .lightGray)
        titleShadow.position = CGPoint(x: title.position.x + 1, y: title.position.y - 2)
        titleShadow.zPosition = 99
        self.addChild(titleShadow)
        
        let musicUrl = Bundle.main.url(forResource: "menu_cloud_theme", withExtension: "mp3")
        let music = SKAudioNode(url: musicUrl!)
        music.autoplayLooped = true
        self.addChild(music)
    }
}
