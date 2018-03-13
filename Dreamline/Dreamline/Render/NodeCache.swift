//
//  NodePool.swift
//  Dreamline
//
//  Created by BeeDream on 3/9/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation
import SpriteKit

// for now these just take in generic SKNodes
// if need be, swap with protocol for more functionality
protocol NodeCache {
    func addNode(_ node: SKNode, data: Trigger)
    func deleteNode(triggerId: Int)
    func updateNodePosition(triggerId: Int, position: CGFloat)
    func fadeOutNode(triggerId: Int)
    func free()
}

class GenericNodeCache: SKNode, NodeCache {
    
    var cachedNodes = [Int: SKNode]()
    
    func addNode(_ node: SKNode, data: Trigger) {
        self.cachedNodes[data.id] = node
        self.addChild(node)
    }
    
    func deleteNode(triggerId: Int) {
        assert(self.cachedNodes[triggerId] != nil)
        
        let node = self.cachedNodes[triggerId]!
        node.removeFromParent() // double check that this doesn't have any weird side effects
        self.cachedNodes.removeValue(forKey: triggerId)
    }
    
    func updateNodePosition(triggerId: Int, position: CGFloat) {
        assert(self.cachedNodes[triggerId] != nil)
        
        let node = self.cachedNodes[triggerId]!
        node.position.y = position
    }
    
    func fadeOutNode(triggerId: Int) {
        assert(self.cachedNodes[triggerId] != nil)
        
        let node = self.cachedNodes[triggerId]!
        node.run(SKAction.fadeOut(withDuration: 0.2))
    }
    
    func free() {
        self.removeAllActions()
        self.removeAllChildren()
        self.cachedNodes.removeAll()
    }
}
