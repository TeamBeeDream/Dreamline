//
//  OrbRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 4/11/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class OrbRendererDelegate: EntityRendererDelegate {
    
    // MARK: Private Properties
    
    private var frame: CGRect!
    private var textures: DictTextureCache<Orb>!
    
    // MARK: Init
    
    static func make(frame: CGRect) -> OrbRendererDelegate {
        let instance = OrbRendererDelegate()
        instance.frame = frame
        instance.textures = DictTextureCache<Orb>.make()
        instance.generateTextures()
        return instance
    }
    
    // MARK: EntityRendererDelegate Methods
    
    func makeNode(entity: Entity) -> SKNode? {
        guard let data = entity.orbData() else { return nil }
        
        let container = SKNode()
        let offset = self.frame.width / 3.0
        var posX = self.frame.width / 6.0
        for orb in data {
            if orb != .none {
                let texture = self.textures.retrieveTexture(key: orb)
                let sprite = SKSpriteNode(texture: texture)
                sprite.position.x = posX
                container.addChild(sprite)
            }
            posX += offset
        }
        return container
    }
    
    func handleEntityStateChange(entity: Entity, node: SKNode) {
        if entity.state == .hit { self.collectOrb(node: node) }
    }
    
    // MARK: Private Methods
    
    private func generateTextures() {
        let shape = SKShapeNode(circleOfRadius: 10.0) // @HARDCODED
        shape.lineWidth = 0.0
        
        shape.fillColor = .yellow
        self.textures.storeTexture(SKView().texture(from: shape)!, forKey: .staminaUp)
        
        shape.fillColor = .cyan
        self.textures.storeTexture(SKView().texture(from: shape)!, forKey: .speedUp)
    }
    
    private func collectOrb(node: SKNode) {
        node.run(SKAction.fadeOut(withDuration: 0.15))
    }
}
