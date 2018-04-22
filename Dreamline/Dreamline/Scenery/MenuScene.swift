//
//  MenuScene.swift
//  Dreamline
//
//  Created by BeeDream on 4/13/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    // MARK: Private Properties
    
    private var sceneDelegate: SceneDelegate!
    
    // MARK: Init
    
    static func make(size: CGSize, delegate: SceneDelegate) -> MenuScene {
        let instance = MenuScene(size: size)
        instance.sceneDelegate = delegate
        return instance
    }
    
    // MARK: SKScene Methods
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .darkGray

        let menuLabel = self.basicLabel(text: "Menu Screen")
        menuLabel.position = self.pos(view.frame, y: 0.1)
        menuLabel.fontSize = 36.0
        self.addChild(menuLabel)
        
        let playLabel = self.basicLabel(text: "Play game")
        playLabel.position = self.pos(view.frame, y: 0.5)
        self.addChild(playLabel)
        
        let cardLabel = self.basicLabel(text: "Manage cards")
        cardLabel.position = self.pos(view.frame, y: 0.6)
        self.addChild(cardLabel)
        
        let settingsLabel = self.basicLabel(text: "Settings")
        settingsLabel.position = self.pos(view.frame, y: 0.7)
        self.addChild(settingsLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.sceneDelegate.didTransition(to: .game)
    }
    
    // MARK: Private Methods
    
    private func basicLabel(text: String,
                            color: UIColor = UIColor.darkText,
                            size: CGFloat = 24.0) -> SKLabelNode {
        let label = SKLabelNode(text: text)
        label.fontColor = color
        label.fontSize = size
        return label
    }
    
    private func pos(_ frame: CGRect, y: CGFloat) -> CGPoint {
        return CGPoint(x: frame.midX, y: frame.maxY - frame.height * y)
    }
}
