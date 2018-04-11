//
//  OrbRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 4/11/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class OrbRenderer: Observer {
    
    // MARK: Private Properties
    
    private var scene: SKScene!
    private var nodes = [Int: SKNode]()
    
    private var orbTexture: SKTexture!
    private let orbColor = SKColor.green
    
    // MARK: Init
    
    static func make(scene: SKScene) -> OrbRenderer {
        let instance = OrbRenderer()
        instance.scene = scene
        return instance
    }
    
    // MARK: Observer Methods
    
    func setup(state: KernelState) {
        // Create common orb texture
        let shape = SKShapeNode(circleOfRadius: 10.0) // @HARDCODED
        shape.lineWidth = 0.0
        shape.fillColor = self.orbColor
        shape.zPosition = 4 // @HARDCODED
        let texture = SKView().texture(from: shape)
        self.orbTexture = texture
        
        // @TODO: Sync with state
    }
    
    func observe(events: [KernelEvent]) {
        for event in events {
            switch event {
                
                // @NOTE: Since this entire class only really handles events
                // involving entities of type .orb, it may make sense to add
                // a mask filter to prevent having to check everytime
                
            case .entityAdded(let entity):
                self.addOrb(entity: entity)
                
            case .entityRemoved(let id):
                self.removeOrb(id: id)
                
            case .entityStateChanged(let entity):
                if entity.isA(.orb) && entity.state == .hit {
                    self.collectOrb(id: entity.id)
                }
                
            case .boardScrolled(_, let delta):
                self.moveOrbs(delta: delta)
                
            default: break
            }
        }
    }
    
    // MARK: Private Methods
    
    private func addOrb(entity: Entity) {
        if !entity.isA(.orb) { return }
        
        let container = SKNode()
        // @NOTE: Should replace with convenience alignment method
        let offset = self.scene.frame.width / 3.0
        var posX = self.scene.frame.width / 6.0
        
        let orbs = entity.orbData()!
        for orb in orbs {
            if orb != .none {
                let texture = self.orbTexture
                let sprite = SKSpriteNode(texture: texture)
                sprite.position.x = posX
                sprite.position.y = self.scene.frame.maxY // @FIXME
                container.addChild(sprite)
            }
            posX += offset
        }
        
        self.scene.addChild(container)
        self.nodes[entity.id] = container
    }
    
    private func removeOrb(id: Int) {
        // @ROBUSTNESS
        if self.nodes[id] == nil { return }
        
        let orb = self.nodes[id]!
        orb.removeFromParent()
        self.nodes[id] = nil
    }
    
    private func moveOrbs(delta: Double) {
        for id in self.nodes.keys {
            self.nodes[id]!.position.y -= CGFloat(delta / 2.0) * self.scene.frame.height // @FIXME
        }
    }
    
    private func collectOrb(id: Int) {
        // @ROBUSTNESS
        if self.nodes[id] == nil { return }
        
        let orb = self.nodes[id]!
        orb.run(SKAction.fadeOut(withDuration: 0.15))
    }
}
