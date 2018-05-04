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
        self.backgroundColor = UIColor(red: 154.0/255.0,
                                       green: 227.0/255.0,
                                       blue: 239.0/255.0,
                                       alpha: 1.0)
        self.addClouds()
        self.addTitle()
        self.addTapLabel()
        self.addMusic()
        self.addNextButton()
        self.addCopyright()
    }
    
    private func addTitle() {
        let title = HoppingLabelNode.make(text: "DREAMLINE",
                                          font: "ArialRoundedMTBold",
                                          width: self.frame.width * 0.8,
                                          color: UIColor(red: 247.0/255.0, green: 54.0/255.0, blue: 60.0/255.0, alpha: 1.0))
        title.position = CGPoint(x: self.frame.midX, y: self.frame.midY + self.frame.height * 0.2)
        title.zPosition = 100
        self.addChild(title)
        
        // @HACK
        let titleShadow = HoppingLabelNode.make(text: "DREAMLINE",
                                                font: "ArialRoundedMTBold",
                                                width: self.frame.width * 0.8,
                                                //color: .white)
                                                color: UIColor(red: 255.0/255.0, green: 135.0/255.0, blue: 156.0/255.0, alpha: 1.0))
        titleShadow.position = CGPoint(x: title.position.x, y: title.position.y - 2)
        titleShadow.zPosition = 99
        self.addChild(titleShadow)
    }
    
    private func addTapLabel() {
        let label = SKLabelNode(text: "Tap to play")
        label.fontName = "Avenir-Medium"
        label.fontColor = .white
        label.fontSize = 28
        label.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        label.run(Actions.fadeLoop(duration: 3.0))
        label.zPosition = 100
        self.addChild(label)
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
        let music = Resources.shared.getMusic(.menu)
        music.autoplayLooped = true
        self.addChild(music)
    }
    
    private func addClouds() {
        self.addChild(ScrollingCloudClusterNode.make(count: 4, bounds: self.frame, vertical: false))
    }
    
    private func addCopyright() {
        let label = SKLabelNode(text: "(c) 2018 Team BeeDream")
        label.fontSize = 18
        label.fontColor = .darkText
        label.zPosition = 100
        label.position = CGPoint(x: self.frame.midX, y: self.frame.minY)
        label.verticalAlignmentMode = .bottom
        self.addChild(label)
    }
}
