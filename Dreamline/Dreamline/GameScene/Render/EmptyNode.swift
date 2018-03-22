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
    
    // Would be weird if information is no longer passed
    // through the constructor, instead the parent just sends
    // events that configure the object
    // Could be like:
    // let node = EmptyNode()
    // node.sendEvents([Event])
    // if it is deterministic, then you know
    // that the node is exactly how you want it
    
    // @NOTE: It's weird that I have to do this in order
    //        to have a generic init method
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // @RENAME
    func drawOnce(frameMinX: CGFloat, frameMaxX: CGFloat) {
        
        let leftPoint = CGPoint(x: frameMinX, y: 0.0)
        let rightPoint = CGPoint(x: frameMaxX, y: 0.0)
        let graphic = EmptyNode.createLine(from: leftPoint,
                                            to: rightPoint,
                                            color: SKColor(red: 87.0/255.0,
                                                           green: 91.0/255.0,
                                                           blue: 93.0/255.0,
                                                           alpha: 0.7))
        addChild(graphic)
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
