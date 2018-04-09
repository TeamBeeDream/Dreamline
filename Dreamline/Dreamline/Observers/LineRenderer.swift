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
    
    private var scene: SKScene!
    private var lines = [Int: SKNode]()
    private var ids = [Int]()
    
    private var barrierTexture: SKTexture!
    
    // MARK: Init
    
    static func make() -> LineRenderer {
        let instance = LineRenderer()
        return instance
    }
    
    // MARK: Observer Methods
    
    func setup(state: KernelState, scene: SKScene) {
        // @TODO: setup lines based on given state
        self.scene = scene
        self.generateTextures()
    }
    
    func observe(events: [KernelEvent]) {
        for event in events {
            switch event {
                
            case .entityAdded(let data):
                self.addLine(entity: data)
                
            case .entityRemoved(let id):
                self.removeLine(id: id)
                
            case .boardScrolled(let distance):
                self.moveLines(distance: distance)
                
            case .entityMarkedInactive(let id):
                self.fadeOutLine(id: id)
                
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
                if !gate { posX += offset; continue }
                
                let lineTexture = self.barrierTexture
                let sprite = SKSpriteNode(texture: lineTexture)
                sprite.position.x = posX
                sprite.position.y = self.scene.frame.maxY
                sprite.zPosition = TestScene.LINE_Z_POSITION
                posX += offset
                container.addChild(sprite)
            }
            
            self.scene.addChild(container)
            self.lines[entity.id] = container
            self.ids.append(entity.id)
            
        default: break
        }
    }
    
    private func removeLine(id: Int) {
        let line = self.lines[id]!
        line.removeFromParent() // @TODO: Pool line sprites
        self.lines[id] = nil
        self.ids = self.ids.filter { $0 != id }
    }
    
    private func fadeOutLine(id: Int) {
        let line = self.lines[id]!
        line.run(SKAction.fadeOut(withDuration: 0.2)) // @HARDCODED
    }
    
    private func moveLines(distance: Double) {
        for id in self.ids {
            let line = self.lines[id]!
            line.position.y -= CGFloat(distance / 2.0) * self.scene.frame.height // @FIXME
        }
    }
    
    private func generateTextures() {
        let frame = self.scene.frame
        let lineRect = CGRect(x: 0.0, y: 0.0, width: frame.width / 3.0, height: 2.0)
        let line = self.makeLine(rect: lineRect, color: .cyan)
        self.barrierTexture = SKView().texture(from: line)!
    }

    private func makeLine(rect: CGRect, color: SKColor) -> SKShapeNode {
        let line = SKShapeNode(rect: rect)
        line.lineWidth = 0.0
        line.fillColor = color
        return line
    }
}
