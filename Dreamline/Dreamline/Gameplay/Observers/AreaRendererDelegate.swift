//
//  AreaRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 4/10/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class AreaRendererDelegate: EntityRendererDelegate {
    
    // MARK: Private Properties
    
    private var frame: CGRect!
    private var textures: DictTextureCache<Area>!
    private let areaBlinkKey = "areaBlinkAction"
    
    private let badAreaColor = SKColor.red
    private let goodAreaColor = SKColor.cyan
    
    // MARK: Init
    
    static func make(frame: CGRect, state: KernelState) -> AreaRendererDelegate {
        let instance = AreaRendererDelegate()
        instance.frame = frame
        instance.textures = DictTextureCache<Area>.make()
        instance.generateTextures(state: state)
        return instance
    }

    // MARK: EntityRendererDelegate Methods
    
    func makeNode(entity: Entity) -> SKNode? {
        guard let data = entity.areaData() else { return nil }
        
        let container = SKNode()
        
        let offset = self.frame.width / 3.0
        var posX = self.frame.width / 6.0
        for area in data {
            if area == .none { posX += offset; continue }

            let areaTexture = self.textures.retrieveTexture(key: area)
            let sprite = SKSpriteNode(texture: areaTexture)
            sprite.position.x = posX
            sprite.position.y = sprite.size.height * 0.5
            posX += offset
            container.addChild(sprite)
        }
        
        return container
    }
    
    func handleEntityStateChange(entity: Entity, node: SKNode) {
        if entity.state == .over { self.blinkArea(node: node) }
    }
    
    // MARK: Private Methods
    
    private func generateTextures(state: KernelState) {
        let areaHeight = Double(frame.height) / 2.0 * state.boardState.layout.distanceBetweenEntities
        let areaRect = CGRect(x: 0.0, y: 0.0,
                              width: frame.width / 3.0,
                              height: CGFloat(areaHeight))
        let shape = SKShapeNode(rect: areaRect)
        shape.lineWidth = 0.0
        
        shape.fillColor = self.badAreaColor
        self.textures.storeTexture(SKView().texture(from: shape)!, forKey: Area.bad)
        
        shape.fillColor = self.goodAreaColor
        self.textures.storeTexture(SKView().texture(from: shape)!, forKey: Area.good)
    }
    
    private func blinkArea(node: SKNode) {
        let blinkAction = SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.2),
            SKAction.fadeIn(withDuration: 0.1)])

        if node.action(forKey: self.areaBlinkKey) == nil {
            node.run(blinkAction, withKey: self.areaBlinkKey)
        }
    }
}
