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
        //print(row)
        
        for (i, modifier) in row.pattern.enumerated() {
            switch (modifier) {
            case .none:
                break
            case .speedUp:
                let node = SKShapeNode(circleOfRadius: 12.0) // @HARDCODED
                node.fillColor = SKColor.clear
                node.strokeColor = SKColor.cyan
                node.lineWidth = 2.0
                node.position.x = positions[i].x
                self.addChild(node)
                break
            case .speedDown:
                let node = SKShapeNode(circleOfRadius: 12.0) // @HARDCODED
                node.fillColor = SKColor.clear
                node.strokeColor = SKColor.purple
                node.lineWidth = 2.0
                node.position.x = positions[i].x
                self.addChild(node)
                break
            }
        }
    }
}
