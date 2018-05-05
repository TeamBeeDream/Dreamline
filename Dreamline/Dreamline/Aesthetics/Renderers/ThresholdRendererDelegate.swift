//
//  ThresholdRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 4/10/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class ThresholdRendererDelegate: EntityRendererDelegate {
    
    // MARK: Private Properties
    
    private var frame: CGRect!
    
    // MARK: Init
    
    static func make(frame: CGRect) -> ThresholdRendererDelegate {
        let instance = ThresholdRendererDelegate()
        instance.frame = frame
        return instance
    }
    
    // MARK: EntityRendererDelegate
    
    func makeNode(entity: Entity) -> SKSpriteNode? {
        switch entity.type {
        case .threshold(let type):
            let texture = self.getTexture(type: type)
            let sprite = SKSpriteNode(texture: texture)
            sprite.position.x = self.frame.midX
            //sprite.zPosition = GameScene.LINE_Z_POSITION // @HARDCODED
            sprite.zPosition = 5
            return sprite
        default:
            return nil
        }
    }
    
    func handleEntityStateChange(state: EntityState, node: SKSpriteNode) {
        switch state {
        case .crossed:
            node.run(Actions.blink(duration: 0.2))
        default:
            break
        }
    }
    
    private func getTexture(type: ThresholdType) -> SKTexture {
        switch type {
        case .chunkEnd: return Resources.shared.getTexture(.thresholdChunk)
        case .roundEnd: return Resources.shared.getTexture(.thresholdRound)
        case .recovery: return Resources.shared.getTexture(.thresholdRecovery)
        }
    }
}
