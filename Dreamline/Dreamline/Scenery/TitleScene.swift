//
//  TitleScene.swift
//  Dreamline
//
//  Created by BeeDream on 4/13/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class TitleScene: SKScene {
    
    // MARK: Private Properties
    
    private var sceneDelegate: SceneDelegate!
    
    // MARK: Init
    
    static func make(size: CGSize, delegate: SceneDelegate) -> TitleScene {
        let instance = TitleScene(size: size)
        instance.sceneDelegate = delegate
        return instance
    }
    
    // MARK: SKScene Methods
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .cyan
        
        let label = SKLabelNode(text: "dreamline")
        label.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        label.fontColor = .darkText
        label.fontSize = 36
        self.addChild(label)
        
        let continueLabel = SKLabelNode(text: "Tap to continue")
        continueLabel.position = CGPoint(x: view.frame.midX, y: view.frame.midY - view.frame.height * 0.25) // gross
        continueLabel.fontColor = .darkText
        continueLabel.fontSize = 24
        self.addChild(continueLabel)
        
        let copyright = SKLabelNode(text: "© Team BeeDream 2018")
        copyright.position = CGPoint(x: view.frame.midX, y: view.frame.minY)
        copyright.verticalAlignmentMode = .bottom
        copyright.fontColor = .darkText
        copyright.fontSize = 16
        self.addChild(copyright)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.sceneDelegate.didTransition(to: .menu)
    }
}
