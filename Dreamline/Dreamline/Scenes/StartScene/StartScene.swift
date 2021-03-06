//
//  StartScene.swift
//  Dreamline
//
//  Created by BeeDream on 3/12/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation
import SpriteKit

class StartScene: CustomScene {
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor(red: 149.0/255.0, green: 147.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        
        let text = SKLabelNode(text: "tap to play") // @HARDCODED
        text.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        text.fontColor = SKColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
        self.addChild(text)
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let watermark = SKLabelNode(text: "Dreamline BETA \(version ?? "")")
        watermark.fontColor = .darkText
        watermark.fontSize = 20
        watermark.alpha = 0.65
        watermark.position = CGPoint(x: view.frame.maxX - 5.0, y: view.frame.minY + 5.0)
        watermark.horizontalAlignmentMode = .right
        self.addChild(watermark)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // @FIXME
        self.manager.transitionToGameScene()
    }
}
