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
    private var textures: DictTextureCache<ThresholdType>!
    
    // MARK: Init
    
    static func make(frame: CGRect) -> ThresholdRendererDelegate {
        let instance = ThresholdRendererDelegate()
        instance.frame = frame
        instance.textures = DictTextureCache<ThresholdType>.make()
        instance.generateTextures()
        return instance
    }
    
    // MARK: EntityRendererDelegate
    
    func makeNode(entity: Entity) -> SKNode? {
        switch entity.type {
        case .threshold(let type):
            let texture = self.textures.retrieveTexture(key: type)
            let sprite = SKSpriteNode(texture: texture)
            sprite.position.x = self.frame.midX
            //sprite.zPosition = GameScene.LINE_Z_POSITION // @HARDCODED
            sprite.zPosition = 5
            return sprite
        default:
            return nil
        }
    }
    
    func handleEntityStateChange(entity: Entity, node: SKNode) {
        
    }
    
    // MARK: Private Methods
    
    private func generateTextures() {
        let rect = CGRect(x: 0.0,
                          y: 0.0,
                          width: self.frame.width,
                          height: 2.0)
        let shape = SKShapeNode(rect: rect)
        shape.lineWidth = 0.0
        
        shape.fillColor = .yellow // @HARDCODED
        self.textures.storeTexture(SKView().texture(from: shape)!, forKey: .chunkEnd)
        
        shape.fillColor = .green
        self.textures.storeTexture(SKView().texture(from: shape)!, forKey: .roundEnd)
    }
}
