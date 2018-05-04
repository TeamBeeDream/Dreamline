//
//  ButtonNode.swift
//  Dreamline
//
//  Created by BeeDream on 4/25/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class ButtonNode: SKSpriteNode {
    
    var action: (() -> Void)?
    var soundEnabled = true
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.pressButton()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.action?()
        if self.soundEnabled {
            self.scene?.run(Resources.shared.getSound(.menuClick))
        }
        self.releaseButton()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.releaseButton()
    }
    
    private func pressButton() {
        self.removeAllActions()
        self.run(SKAction.fadeAlpha(to: 0.8, duration: 0.02))
    }
    
    private func releaseButton() {
        self.removeAllActions()
        self.run(SKAction.fadeAlpha(to: 1.0, duration: 0.02))
    }
}
