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
    
    private var view: SKView!
    private var lines = [Int: SKSpriteNode]()
    private var ids = [Int]()
    
    private var texture: SKTexture!
    
    // MARK: Init
    
    static func make(view: SKView) -> LineRenderer {
        let instance = LineRenderer()
        instance.view = view
        instance.texture = view.texture(from: instance.makeLine()) // Whoa
        return instance
    }
    
    // MARK: Observer Methods
    
    func observe(events: [KernelEvent]) {
        for event in events {
            switch event {
                
            case .barrierAdded(let data):
                self.addLine(entity: data)
                
            case .barrierRemoved(let id):
                self.removeLine(id: id)
                
            case .boardScrolled(let distance):
                self.moveLines(distance: distance)
                
            default:
                break
            }
        }
    }
    
    // MARK: Private Methods
    
    private func addLine(entity: EntityData) {
        let sprite = SKSpriteNode(texture: self.texture)
        sprite.zPosition = TestScene.LINE_Z_POSITION
        sprite.position.x = self.view.frame.midX
        
        self.view.scene!.addChild(sprite)
        self.lines[entity.id] = sprite
        self.ids.append(entity.id)
    }
    
    private func removeLine(id: Int) {
        let line = self.lines[id]!
        line.removeFromParent() // @TODO: Pool line sprites
        self.lines[id] = nil
        self.ids = self.ids.filter { $0 != id }
    }
    
    private func moveLines(distance: Double) {
        for id in self.ids {
            let line = self.lines[id]!
            line.position.y += CGFloat(distance / 2.0) * self.view.frame.height // @FIXME
        }
    }
    
    private func makeLine(width: Double = 1.0) -> SKShapeNode {
        let rect = CGRect(x: 0.0, y: 0.0, width: Double(self.view.frame.width), height: width)
        let line = SKShapeNode(rect: rect)
        line.lineWidth = 0.0
        line.fillColor = .red
        line.zPosition = TestScene.LINE_Z_POSITION
        line.blendMode = .add
        return line
    }
    
    private func calcPosition(_ position: Double) -> CGFloat {
        let value = lerp(CGFloat(position + 1.0) / 2.0,
                         min: self.view.frame.minY,
                         max: self.view.frame.maxY)
        return value
    }
}
