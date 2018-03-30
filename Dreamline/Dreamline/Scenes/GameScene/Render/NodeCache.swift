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
    func addNode(_ node: SKNode, entity: Entity)
    func deleteNode(id: Int)
    func updateNodePosition(id: Int, position: CGFloat)
    func fadeOutNode(id: Int)
    func free()
}

class GenericNodeCache: SKNode, NodeCache {
    
    var cachedNodes = [Int: SKNode]()
    
    func addNode(_ node: SKNode, entity: Entity) {
        self.cachedNodes[entity.id] = node
        self.addChild(node)
    }
    
    func deleteNode(id: Int) {
        assert(self.cachedNodes[id] != nil)
        
        let node = self.cachedNodes[id]!
        node.removeFromParent() // double check that this doesn't have any weird side effects
        self.cachedNodes.removeValue(forKey: id)
    }
    
    func updateNodePosition(id: Int, position: CGFloat) {
        assert(self.cachedNodes[id] != nil)
        
        let node = self.cachedNodes[id]!
        node.position.y = position
    }
    
    func fadeOutNode(id: Int) {
        assert(self.cachedNodes[id] != nil)
        
        let node = self.cachedNodes[id]!
        node.run(SKAction.fadeOut(withDuration: 0.2))
    }
    
    func free() {
        self.removeAllActions()
        self.removeAllChildren()
        self.cachedNodes.removeAll()
    }
}
