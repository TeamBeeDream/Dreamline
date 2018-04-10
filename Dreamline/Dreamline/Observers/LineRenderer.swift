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
    
    // @TODO: Separate out area rendering
    private var areaTexture: SKTexture!
    private let areaBlinkKey = "areaBlinkAction"
    
    // @TEMP
    private let lineColor = SKColor.red
    private let areaColor = SKColor.darkGray
    
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
                
            case .entityAdded(let data):
                self.addLine(entity: data)
                
            case .entityRemoved(let id):
                self.removeLine(id: id)

            case .entityStateChanged(let entity):
                if entity.state == .hit { self.blinkLine(id: entity.id) }
                if entity.state == .passed { self.fadeOutLine(id: entity.id) }
                if entity.state == .over { self.blinkArea(entity: entity) }
                
            case .boardScrolled(_, let delta):
                self.moveLines(delta: delta)
            
            // @TODO: Handle .entityMoved
                
            default:
                break
            }
        }
    }
    
    // MARK: Private Methods
    
    private func addLine(entity: EntityData) {
        
        switch entity.type {
        case .barrier(let gates):
            let container = SKNode()
            let offset = self.scene.frame.width / 3.0
            var posX = self.scene.frame.width / 6.0
            for gate in gates {
                if gate { posX += offset; continue }
                
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
            
        case .area(let gates):
            let container = SKNode()
            let offset = self.scene.frame.width / 3.0
            var posX = self.scene.frame.width / 6.0
            for gate in gates {
                if !gate { posX += offset; continue }
                
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
    
    private func blinkArea(entity: EntityData) {
        
        switch entity.type {
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
        
        let areaHeight = Double(frame.height) / 2.0 * state.boardState.layout.distanceBetweenEntities
        let areaRect = CGRect(x: 0.0, y: 0.0,
                              width: frame.width / 3.0,
                              height: CGFloat(areaHeight))
        let area = self.makeRect(rect: areaRect, color: self.areaColor)
        self.areaTexture = SKView().texture(from: area)
    }

    private func makeRect(rect: CGRect, color: SKColor) -> SKShapeNode {
        let shape = SKShapeNode(rect: rect)
        shape.lineWidth = 0.0
        shape.fillColor = color
        return shape
    }
}
