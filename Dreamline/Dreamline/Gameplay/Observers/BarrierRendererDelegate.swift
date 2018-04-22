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
    private var textures: DictTextureCache<Int>!
    private var barrierColor = SKColor.red
    
    // MARK: Init
    
    static func make(frame: CGRect) -> BarrierRendererDelegate {
        let instance = BarrierRendererDelegate()
        instance.frame = frame
        instance.textures = DictTextureCache.make()
        instance.generateTextures()
        return instance
    }
    
    // MARK: EntityRenderDelegate Methods
    
    func makeNode(entity: Entity) -> SKNode? {
        if !entity.isA(.barrier) { return nil }
        
        let gates = entity.barrierData()!
        
        let container = SKNode()
        let offset = self.frame.width / 3.0
        var posX = self.frame.width / 6.0
        for gate in gates {
            if gate == .open { posX += offset; continue }
            
            let texture = self.textures.retrieveTexture(key: 0) // @HARDCODED
            let sprite = SKSpriteNode(texture: texture)
            sprite.position.x = posX
            sprite.zPosition = GameScene.LINE_Z_POSITION
            posX += offset
            container.addChild(sprite)
        }
        return container
    }
    
    func handleEntityStateChange(entity: Entity, node: SKNode) {
        if entity.state == .hit { self.blinkLine(node: node) }
        if entity.state == .passed { self.fadeOutLine(node: node) }
    }
    
    // MARK: Private Methods
    
    private func generateTextures() {
        let rect = CGRect(x: 0.0,
                          y: 0.0,
                          width: frame.width / 3.0,
                          height: 2.0)
        let shape = SKShapeNode(rect: rect)
        shape.lineWidth = 0.0
        shape.fillColor = self.barrierColor
        
        let texture = SKView().texture(from: shape)!
        self.textures.storeTexture(texture, forKey: 0) // @HARDCODED
    }
    
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
