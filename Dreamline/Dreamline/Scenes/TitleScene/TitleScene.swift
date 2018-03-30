//
//  TitleScene.swift
//  Dreamline
//
//  Created by BeeDream on 3/16/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class TitleScene: CustomScene {
    
    var teambeedreamLogo: SKNode?
    var title: SKNode?
    
    override func onInit() {
        self.teambeedreamLogo = SKSpriteNode(imageNamed: "TeamBeeDreamLogo")
        self.title = SKLabelNode(text: "Team BeeDream")
        
        self.backgroundColor = SKColor(red: 247.0/255.0, green: 162.0/255.0, blue: 104.0/255.0, alpha: 1.0)
    }
    
    override func didMove(to view: SKView) {
        let delay = SKAction.wait(forDuration: 0.5)
        let fadeIn = SKAction.fadeIn(withDuration: 1.0)
        let hold = SKAction.wait(forDuration: 1.0)
        let fadeOut = SKAction.fadeOut(withDuration: 0.75)
        
        let size = self.frame.width * 0.2
        
        let logo: SKSpriteNode = self.teambeedreamLogo! as! SKSpriteNode
        logo.alpha = 0.0
        logo.size = CGSize(width: size, height: size)
        logo.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        logo.run(SKAction.sequence([delay, fadeIn, hold, fadeOut]))
        self.addChild(logo)
        
        let title = self.title! as! SKLabelNode
        title.alpha = 0.0
        title.fontSize = title.fontSize * 0.8
        title.fontColor = SKColor(red: 112.0/255.0, green: 60.0/255.0, blue: 76.0/255.0, alpha: 1.0)
        title.position = CGPoint(x: self.frame.midX, y: self.frame.midY - size)
        title.run(SKAction.sequence([delay, fadeIn, hold, fadeOut]))
        self.addChild(title)
        
        // @TODO: Should only have to pass .next instead of
        //        specifying exactly which scene to move to
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 4),
            SKAction.run { self.manager.transitionToInfoScene() }]))
    }
}
