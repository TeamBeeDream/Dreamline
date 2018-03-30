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
    
    static let graphicWidth: CGFloat = 35.0 // @HARDCODED
    
    func drawOnce(row: ModifierRow, positions: [CGPoint]) {
        
        for (i, modifier) in row.modifiers.enumerated() {
            switch (modifier) {
            case .none:
                break
            case .speedUp:
                let node = SKSpriteNode(imageNamed: "SpeedUp")
                node.size = CGSize(width: ModifierNode.graphicWidth, height: ModifierNode.graphicWidth)
                node.position.x = positions[i].x
                self.addChild(node)
                break
            case .speedDown:
                let node = SKSpriteNode(imageNamed: "SpeedDown")
                node.size = CGSize(width: ModifierNode.graphicWidth, height: ModifierNode.graphicWidth)
                node.position.x = positions[i].x
                self.addChild(node)
                break
            }
        }
    }
}
