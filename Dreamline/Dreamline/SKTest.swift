//
//  SKTest.swift
//  Dreamline
//
//  Created by BeeDream on 3/21/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation
import SpriteKit

class SKTest: SKView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.allowsTransparency = true // THIS IS IMPORTANT
        self.preferredFramesPerSecond = 60 // @HARDCODED
        self.presentScene(TestScene(size: frame.size))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TestScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.backgroundColor = .clear // THIS IS IMPORTANT
        
        let label = SKLabelNode(text: "SpriteKit + MetalKit")
        label.position = CGPoint(x: frame.midX, y: frame.midY)
        label.fontColor = .darkText
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

