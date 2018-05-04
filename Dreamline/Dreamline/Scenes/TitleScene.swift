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
        self.backgroundColor = Colors.sky
        self.addClouds()
        self.addTitle()
        self.addTapLabel()
        self.addMusic()
        self.addNextButton()
        self.addCopyright()
    }
    
    private func addTitle() {
        let moveUp = SKAction.moveBy(x: 0.0, y: self.frame.height * 0.1, duration: 1.2)
        moveUp.timingMode = .easeOut
        
        let title = HoppingLabelNode.make(text: "CLOUD COURSE",
                                          font: "ArialRoundedMTBold",
                                          width: self.frame.width * 0.95,
                                          color: Colors.red,
                                          secondaryColor: Colors.orange)
        title.position = CGPoint(x: self.frame.midX, y: self.frame.midY + self.frame.height * 0.1)
        title.zPosition = 100
        title.alpha = 0.0
        title.run(SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.group([
                SKAction.fadeIn(withDuration: 1.0),
                moveUp])
            ]))
        self.addChild(title)
    }
    
    private func addTapLabel() {
        let label = SKLabelNode(text: "Tap to play")
        label.fontName = "Avenir-Medium"
        label.fontColor = .white
        label.fontSize = 28
        label.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        label.zPosition = 100
        label.alpha = 0.0
        label.run(SKAction.sequence([
            SKAction.wait(forDuration: 3.5),
            SKAction.fadeIn(withDuration: 1.5),
            Actions.fadeLoop(duration: 3.0)]))
        self.addChild(label)
    }
    
    private func addNextButton() {
        let button = ButtonNode(color: .clear, size: self.frame.size)
        button.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        button.zPosition = 200
        button.action = { self.manager.gotoGame() } // @TEMP
        button.run(SKAction.sequence([
            SKAction.wait(forDuration: 3.5),
            SKAction.run { button.isUserInteractionEnabled = true }]))
        self.addChild(button)
    }
    
    private func addMusic() {
        let music = Resources.shared.getMusic(.menu)
        music.autoplayLooped = true
        self.addChild(music)
    }
    
    private func addClouds() {
        let clouds = ScrollingCloudClusterNode.make(count: 4, bounds: self.frame, vertical: false)
        clouds.alpha = 0.0
        clouds.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.5),
            Actions.fadeIn(duration: 3.0)]))
        self.addChild(clouds)
    }
    
    private func addCopyright() {
        let fadeIn = SKAction.sequence([
            SKAction.wait(forDuration: 4.0),
            SKAction.fadeIn(withDuration: 1.0)])
        
        let width = self.frame.width * 0.15
        let size = CGSize(width: width, height: width)
        let logo = SKSpriteNode(texture: Resources.shared.getTexture(.tbdLogo),
                                size: size)
        logo.zPosition = 40
        logo.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 15.0 + width)
        logo.alpha = 0.0
        logo.run(fadeIn)
        self.addChild(logo)
        
        let label = SKLabelNode(text: "© 2018 Team BeeDream")
        label.fontSize = 18
        label.fontName = "Avenir-Light"
        label.fontColor = Colors.gray
        label.zPosition = 100
        label.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 15.0)
        label.verticalAlignmentMode = .bottom
        label.alpha = 0.0
        label.run(fadeIn)
        self.addChild(label)
    }
}
