//
//  ThresholdNode.swift
//  Dreamline
//
//  Created by BeeDream on 3/30/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

// @NOTE: This class should only be responsible for drawing
// a horizontal line across the screen, and all behavior
// should be defined by a controller class
class ThresholdNode: SKNode {
    
    // MARK: Init
    
    static func make(frame: CGRect, type: ThresholdType) -> ThresholdNode {
        let node = ThresholdNode()
        var color: SKColor { // @HARDCODED
            switch type {
            case .roundOver: return .red // @TODO
            case .speedUp: return SKColor(red: 210.0/255.0, green: 72.0/255.0, blue: 88.0/255.0, alpha: 1.0)
            }
        }
        node.drawOnce(frameMinX: frame.minX,
                      frameMaxX: frame.maxX,
                      color: color)
        return node
    }
    
    // MARK: Private Methods
    
    private func drawOnce(frameMinX: CGFloat, frameMaxX: CGFloat, color: SKColor) {
        
        let leftPoint = CGPoint(x: frameMinX, y: 0.0)
        let rightPoint = CGPoint(x: frameMaxX, y: 0.0)
        let graphic = self.createLine(from: leftPoint,
                                      to: rightPoint,
                                      color: color,
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
        node.lineCap = .round
        return node
    }
}
