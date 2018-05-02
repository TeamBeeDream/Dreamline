//
//  TitleScene.swift
//  Dreamline
//
//  Created by BeeDream on 5/2/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class TitleScene: SKScene {
    
    private var manager: SceneManager!
    
    static func make(size: CGSize, manager: SceneManager) -> TitleScene {
        let instance = TitleScene(size: size)
        instance.manager = manager
        return instance
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .cyan
        self.addBackground()
        self.addTitle()
        self.addTapLabel()
        self.addMusic()
        self.addNextButton()
    }
    
    private func addTitle() {
        let title = HoppingLabelNode.make(text: "DREAMLINE",
                                          font: "AppleSDGothicNeo-Medium",
                                          width: self.frame.width * 0.8,
                                          color: .white)
        title.position = CGPoint(x: self.frame.midX, y: self.frame.midY + self.frame.height * 0.2)
        title.zPosition = 100
        self.addChild(title)
        
        // @HACK
        let titleShadow = HoppingLabelNode.make(text: "DREAMLINE",
                                                font: "AppleSDGothicNeo-Medium",
                                                width: self.frame.width * 0.8,
                                                color: .lightGray)
        titleShadow.position = CGPoint(x: title.position.x + 1, y: title.position.y - 2)
        titleShadow.zPosition = 99
        self.addChild(titleShadow)
    }
    
    private func addTapLabel() {
        let label = SKLabelNode(text: "Tap to play")
        label.fontColor = .white
        label.fontSize = 20
        label.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        label.run(Actions.fadeLoop(duration: 3.0))
        label.zPosition = 100
        self.addChild(label)
    }
    
    private func addBackground() {
        let background = SKSpriteNode(imageNamed: "TitleScreenBGA")
        background.size = CGSize(width: self.frame.height, height: self.frame.height)
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(background)
    }
    
    private func addNextButton() {
        let button = ButtonNode(color: .clear, size: self.frame.size)
        button.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        button.zPosition = 200
        button.isUserInteractionEnabled = true
        button.action = { self.manager.gotoGame() } // @TEMP
        self.addChild(button)
    }
    
    private func addMusic() {
        let musicUrl = Bundle.main.url(forResource: "menu_cloud_theme", withExtension: "mp3")
        let music = SKAudioNode(url: musicUrl!)
        music.autoplayLooped = true
        self.addChild(music)
    }
}
