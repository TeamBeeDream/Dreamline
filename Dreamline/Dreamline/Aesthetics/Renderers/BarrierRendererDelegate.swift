//
//  LineRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 4/7/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class BarrierRendererDelegate: EntityRendererDelegate {
    
    // MARK: Private Properties
    
    private var frame: CGRect! // @ROBUSTNESS
    
    // MARK: Init
    
    static func make(frame: CGRect) -> BarrierRendererDelegate {
        let instance = BarrierRendererDelegate()
        instance.frame = frame
        return instance
    }
    
    // MARK: EntityRenderDelegate Methods
    
    func makeNode(entity: Entity) -> SKSpriteNode? {
        switch entity.type {
        case .barrier(let gates):
            let container = SKSpriteNode()
            let offset = self.frame.width / 3.0
            var posX = self.frame.width / 6.0
            for gate in gates {
                if gate == .open { posX += offset; continue }
                let texture = Resources.shared.getTexture(.barrier)
                let sprite = SKSpriteNode(texture: texture)
                sprite.position.x = posX
                //sprite.zPosition = GameScene.LINE_Z_POSITION
                sprite.zPosition = 5 // @HARDOCDED
                posX += offset
                container.addChild(sprite)
            }
            return container
        default:
            return nil
        }
    }
    
    func handleEntityStateChange(state: EntityState, node: SKSpriteNode) {
        switch state {
        case .crossed:
            node.run(Actions.blink(duration: 0.1))
        case .passed:
            node.run(SKAction.sequence([
                Actions.hop(height: 15.0, duration: 0.15),
                Actions.fadeOut(duration: 0.4)]))
        default:
            break
        }
    }
    
    // MARK: Private Methods
    
    private func fadeOutLine(node: SKNode) {
        node.run(SKAction.fadeOut(withDuration: 0.2))
    }
    
    private func blinkLine(node: SKNode) {
        let blinkAction = SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.1),
            SKAction.fadeIn(withDuration: 0.05)])
        
        node.run(SKAction.repeat(blinkAction, count: 4))
    }
}
