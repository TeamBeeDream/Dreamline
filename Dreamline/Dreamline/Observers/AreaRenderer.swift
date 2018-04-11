//
//  AreaRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 4/10/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class AreaRenderer: Observer {
    
    // MARK: Private Properties
    
    private var scene: SKScene!
    private var nodes = [Int: SKNode]()
    private var ids = [Int]()
    
    private var areaTexture: SKTexture!
    private let areaBlinkKey = "areaBlinkAction"
    private let areaColor = SKColor.darkGray
    
    // MARK: Init
    
    static func make(scene: SKScene) -> AreaRenderer {
        let instance = AreaRenderer()
        instance.scene = scene
        return instance
    }
    
    // MARK: Observer Methods
    
    func setup(state: KernelState) {
        self.generateTextures(state: state)
    }
    
    func observe(events: [KernelEvent]) {
        for event in events {
            switch event {
            case .entityAdded(let entity):
                self.addNode(entity: entity)
                
            case .entityRemoved(let id):
                self.removeNode(id: id)
                
            case .entityStateChanged(let entity):
                if entity.state == .over { self.blinkArea(entity: entity) }
                
            case .boardScrolled(_, let delta):
                self.moveNodes(delta: delta)
                
            default: break
            }
        }
    }
    
    // MARK: Private Methods
    
    private func generateTextures(state: KernelState) {
        let frame = self.scene.frame
        
        let areaHeight = Double(frame.height) / 2.0 * state.boardState.layout.distanceBetweenEntities
        let areaRect = CGRect(x: 0.0, y: 0.0,
                              width: frame.width / 3.0,
                              height: CGFloat(areaHeight))
        let area = self.makeRect(rect: areaRect, color: self.areaColor)
        self.areaTexture = SKView().texture(from: area)
    }
    
    private func addNode(entity: Entity) {
        
        switch entity.data {
            
        case .area(let areas):
            let container = SKNode()
            let offset = self.scene.frame.width / 3.0
            var posX = self.scene.frame.width / 6.0
            for area in areas {
                if area == .inactive { posX += offset; continue }
                
                let areaTexture = self.areaTexture
                let sprite = SKSpriteNode(texture: areaTexture)
                sprite.position.x = posX
                sprite.position.y = self.scene.frame.maxY + sprite.size.height * 0.5 // @CLEANUP @FIXME
                posX += offset
                container.addChild(sprite)
            }
            
            self.scene.addChild(container)
            self.nodes[entity.id] = container
            self.ids.append(entity.id)
            
        default: break
        }
    }
    
    // @DUPLICATED
    private func removeNode(id: Int) {
        // @ROBUSTNESS: Since we're only handling barriers
        // we can't remove *any* entity by its id
        if self.nodes[id] == nil { return }
        
        let line = self.nodes[id]!
        line.removeFromParent() // @TODO: Pool line sprites
        self.nodes[id] = nil
        self.ids = self.ids.filter { $0 != id }
    }
    
    // @DUPLICATED
    private func moveNodes(delta: Double) {
        for id in self.ids {
            let line = self.nodes[id]!
            line.position.y -= CGFloat(delta / 2.0) * self.scene.frame.height // @FIXME
        }
    }
    
    private func blinkArea(entity: Entity) {
        
        switch entity.data {
        case .area:
            let blinkAction = SKAction.sequence([
                SKAction.fadeOut(withDuration: 0.2),
                SKAction.fadeIn(withDuration: 0.1)])
            
            let area = self.nodes[entity.id]!
            if area.action(forKey: self.areaBlinkKey) == nil {
                area.run(blinkAction, withKey: self.areaBlinkKey)
            }
            
        default: break
        }
    }
    
    // @DUPLICATED
    private func makeRect(rect: CGRect, color: SKColor) -> SKShapeNode {
        let shape = SKShapeNode(rect: rect)
        shape.lineWidth = 0.0
        shape.fillColor = color
        return shape
    }
}
