//
//  ThresholdNode.swift
//  Dreamline
//
//  Created by BeeDream on 3/30/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class ThresholdNode: SKNode {
    
    // MARK: Init
    
    static func make(frame: CGRect) -> ThresholdNode {
        let node = ThresholdNode()
        node.drawOnce(frameMinX: frame.minX, frameMaxX: frame.maxX)
        return node
    }
    
    // MARK: Private Methods
    
    private func drawOnce(frameMinX: CGFloat, frameMaxX: CGFloat) {
        
        let leftPoint = CGPoint(x: frameMinX, y: 0.0)
        let rightPoint = CGPoint(x: frameMaxX, y: 0.0)
        let graphic = self.createLine(from: leftPoint,
                                      to: rightPoint,
                                      color: SKColor(red: 200.0/255.0,
                                                     green: 200.0/255.0,
                                                     blue: 200.0/255.0,
                                                     alpha: 0.9),
                                      width: 3.5)
        addChild(graphic)
    }
    
    // @CLEANUP: should probably move this to a shared graphics functions class
    private func createLine(from: CGPoint,
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
