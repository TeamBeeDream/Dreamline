//
//  ThresholdRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 4/10/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class ThresholdRenderer: Observer {
    
    // MARK: Private Properties
   
    private var scene: SKScene!
    private var nodes = [Int: SKNode]()
    private var ids = [Int]()
    
    private var thresholdTexture: SKTexture!
    private let lineColor = SKColor.yellow
    
    // MARK: Init
    
    static func make(scene: SKScene) -> ThresholdRenderer {
        let instance = ThresholdRenderer()
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
                self.addLine(entity: entity)
                
            case .entityRemoved(let id):
                self.removeLine(id: id)
                
//            case .entityStateChanged(let entity):
//                if entity.state == .hit { self.blinkLine(id: entity.id) }
//                if entity.state == .passed { self.fadeOutLine(id: entity.id) }
                
            case .boardScrolled(_, let delta):
                self.moveLines(delta: delta)
                
            default:
                break
            }
        }
    }
    
    // MARK: Private Properties
    
    private func addLine(entity: Entity) {
        
        switch entity.data {
        case .threshold:
            
            let texture = self.thresholdTexture
            let sprite = SKSpriteNode(texture: texture)
            sprite.position.x = self.scene.frame.midX
            sprite.position.y = self.scene.frame.maxY // @CLEANUP @FIXME
            sprite.zPosition = TestScene.LINE_Z_POSITION
            
            self.scene.addChild(sprite)
            self.nodes[entity.id] = sprite
            self.ids.append(entity.id)
            
        default: break
        }
    }
    
    // @DUPLICATED
    private func removeLine(id: Int) {
        // @ROBUSTNESS: Since we're only handling barriers
        // we can't remove *any* entity by its id
        if self.nodes[id] == nil { return }
        
        let line = self.nodes[id]!
        line.removeFromParent() // @TODO: Pool line sprites
        self.nodes[id] = nil
        self.ids = self.ids.filter { $0 != id }
    }

    private func moveLines(delta: Double) {
        for id in self.ids {
            let line = self.nodes[id]!
            line.position.y -= CGFloat(delta / 2.0) * self.scene.frame.height // @FIXME
        }
    }
    
    private func generateTextures(state: KernelState) {
        let frame = self.scene.frame
        
        let lineRect = CGRect(x: 0.0, y: 0.0,
                              width: frame.width,
                              height: 2.0)
        let line = self.makeRect(rect: lineRect, color: self.lineColor)
        self.thresholdTexture = SKView().texture(from: line)!
    }
    
    // @DUPLICATED
    private func makeRect(rect: CGRect, color: SKColor) -> SKShapeNode {
        let shape = SKShapeNode(rect: rect)
        shape.lineWidth = 0.0
        shape.fillColor = color
        return shape
    }
}
