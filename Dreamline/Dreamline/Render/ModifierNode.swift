//
//  ModifierNode.swift
//  Dreamline
//
//  Created by BeeDream on 3/9/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation
import SpriteKit

class ModifierNode: SKNode {
    
    func drawOnce(row: ModifierRow, positions: [CGPoint]) {
        
        for (i, modifier) in row.modifiers.enumerated() {
            switch (modifier) {
            case .none:
                break
            case .speedUp:
                let node = SKShapeNode(circleOfRadius: 12.0) // @HARDCODED
                node.fillColor = SKColor.clear
                node.strokeColor = SKColor(red: 23.0/255.0,
                                           green: 190.0/255.0,
                                           blue: 187.0/255.0,
                                           alpha: 1.0)
                node.lineWidth = 2.0
                node.position.x = positions[i].x
                self.addChild(node)
                break
            case .speedDown:
                let node = SKShapeNode(circleOfRadius: 12.0) // @HARDCODED
                node.fillColor = SKColor.clear
                node.strokeColor = SKColor(red: 239.0/255.0,
                                           green: 62.0/255.0,
                                           blue: 54.0/255.0,
                                           alpha: 1.0)
                node.lineWidth = 2.0
                node.position.x = positions[i].x
                self.addChild(node)
                break
            }
        }
    }
}
