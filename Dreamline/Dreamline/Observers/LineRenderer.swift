//
//  LineRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 4/7/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class LineRenderer: Observer {
    
    // MARK: Private Properties
    
    private var scene: SKScene!     // @TODO: Make public?
    private var nodes = [Int: SKNode]()
    private var ids = [Int]()
    
    private var barrierTexture: SKTexture!
    
    // @TEMP
    private let lineColor = SKColor.red
    
    // MARK: Init
    
    static func make(scene: SKScene) -> LineRenderer {
        let instance = LineRenderer()
        instance.scene = scene
        return instance
    }
    
    // MARK: Observer Methods
    
    func setup(state: KernelState) {
        // @TODO: setup lines based on given state
        self.generateTextures(state: state)
    }
    
    func observe(events: [KernelEvent]) {
        for event in events {
            switch event {
                
            case .entityAdded(let entity):
                self.addLine(entity: entity)
                
            case .entityRemoved(let id):
                self.removeLine(id: id)

            case .entityStateChanged(let entity):
                if entity.state == .hit { self.blinkLine(id: entity.id) }
                if entity.state == .passed { self.fadeOutLine(id: entity.id) }
                
            case .boardScrolled(_, let delta):
                self.moveLines(delta: delta)
                
            default:
                break
            }
        }
    }
    
    // MARK: Private Methods
    
    private func addLine(entity: Entity) {
        
        switch entity.data {
        case .barrier(let gates):
            let container = SKNode()
            let offset = self.scene.frame.width / 3.0
            var posX = self.scene.frame.width / 6.0
            for gate in gates {
                if gate == .open { posX += offset; continue }
                
                let lineTexture = self.barrierTexture
                let sprite = SKSpriteNode(texture: lineTexture)
                sprite.position.x = posX
                sprite.position.y = self.scene.frame.maxY // @CLEANUP @FIXME
                sprite.zPosition = TestScene.LINE_Z_POSITION
                posX += offset
                container.addChild(sprite)
            }
            
            self.scene.addChild(container)
            self.nodes[entity.id] = container
            self.ids.append(entity.id)
            
        default: break
        }
    }
    
    private func removeLine(id: Int) {
        // @ROBUSTNESS: Since we're only handling barriers
        // we can't remove *any* entity by its id
        if self.nodes[id] == nil { return }
        
        let line = self.nodes[id]!
        line.removeFromParent() // @TODO: Pool line sprites
        self.nodes[id] = nil
        self.ids = self.ids.filter { $0 != id }
    }
    
    private func fadeOutLine(id: Int) {
        // @DUPLICATED
        // @ROBUSTNESS: Since we're only handling barriers
        // we can't remove *any* entity by its id
        if self.nodes[id] == nil { return }
        
        let line = self.nodes[id]!
        line.run(SKAction.fadeOut(withDuration: 0.2)) // @HARDCODED
    }
    
    private func blinkLine(id: Int) {
        let blinkAction = SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.1),
            SKAction.fadeIn(withDuration: 0.05)])
        
        let line = self.nodes[id]!
        line.run(SKAction.repeat(blinkAction,
                                 count: 4))
    }
    
    private func moveLines(delta: Double) {
        for id in self.ids {
            let line = self.nodes[id]!
            line.position.y -= CGFloat(delta / 2.0) * self.scene.frame.height // @FIXME
        }
    }
    
    // @ROBUSTNESS
    private func generateTextures(state: KernelState) {
        let frame = self.scene.frame
        
        let lineRect = CGRect(x: 0.0, y: 0.0,
                              width: frame.width / 3.0,
                              height: 2.0)
        let line = self.makeRect(rect: lineRect, color: self.lineColor)
        self.barrierTexture = SKView().texture(from: line)!
    }
    
    // @DUPLICATED
    private func makeRect(rect: CGRect, color: SKColor) -> SKShapeNode {
        let shape = SKShapeNode(rect: rect)
        shape.lineWidth = 0.0
        shape.fillColor = color
        return shape
    }
}
