//
//  EmptyNode.swift
//  Dreamline
//
//  Created by BeeDream on 3/9/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation
import SpriteKit

// @TODO: Factory for nodes like this
class EmptyNode: SKNode {
    var graphic: SKNode
    
    init(frameMinX: Double, frameMaxX: Double) {
        let leftPoint = CGPoint(x: frameMinX, y: 0.0)
        let rightPoint = CGPoint(x: frameMaxX, y: 0.0)
        self.graphic = EmptyNode.createLine(from: leftPoint, to: rightPoint, color: SKColor.gray)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawOnce() {
        addChild(self.graphic) // ugh
    }
    
    // @CLEANUP: should probably move this to a shared graphics functions class
    private static func createLine(from: CGPoint,
                            to: CGPoint,
                            color: SKColor,
                            width: CGFloat = 2.0) -> SKShapeNode {
        let node = SKShapeNode()
        let path = UIBezierPath()
        path.move(to: from)
        path.addLine(to: to)
        node.path = path.cgPath
        node.strokeColor = color
        node.lineWidth = width
        return node
    }
}
