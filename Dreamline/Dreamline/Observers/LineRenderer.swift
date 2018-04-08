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
    
    private var container: SKNode!
    private var frame: CGRect!
    private var lines = [Int: SKShapeNode]()
    private var ids = [Int]()
    
    // MARK: Init
    
    static func make(frame: CGRect, container: SKNode) -> LineRenderer {
        let instance = LineRenderer()
        instance.frame = frame
        instance.container = container
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
        let line = self.makeLine()
        line.position.y = self.calcPosition(entity.position)
        self.container.addChild(line)
        self.lines[entity.id] = line
        self.ids.append(entity.id)
    }
    
    private func removeLine(id: Int) {
        let line = self.lines[id]!
        line.removeFromParent()
        self.lines[id] = nil
        self.ids = self.ids.filter { $0 != id }
    }
    
    private func moveLines(distance: Double) {
        for id in self.ids {
            let line = self.lines[id]!
            line.position.y += CGFloat(distance / 2.0) * self.frame.height // @FIXME
        }
    }
    
    private func makeLine(width: Double = 1.0) -> SKShapeNode {
        let rect = CGRect(x: 0.0, y: 0.0, width: Double(self.frame.width), height: width)
        let line = SKShapeNode(rect: rect)
        line.lineWidth = 0.0
        line.fillColor = .red
        return line
    }
    
    private func calcPosition(_ position: Double) -> CGFloat {
        let value = lerp(CGFloat(position + 1.0) / 2.0,
                         min: self.frame.minY,
                         max: self.frame.maxY)
        //let value = CGFloat((position + 1.0) / 2.0) * self.frame.height
        return value
    }
}
