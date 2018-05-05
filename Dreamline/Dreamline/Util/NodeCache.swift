//
//  NodeCache.swift
//  Dreamline
//
//  Created by BeeDream on 4/11/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

// @MOVE
protocol NodeCache {
    func storeNode(_ node: SKSpriteNode, forId id: Int)
    func retrieveNode(id: Int) -> SKSpriteNode?
    func removeNode(id: Int)
    func iter() -> [(Int, SKSpriteNode)]
}

class DictNodeCache: NodeCache {
    
    // MARK: Private Properties
    
    private var nodes: [Int: SKSpriteNode]!
    
    // MARK: Init
    
    static func make() -> DictNodeCache {
        let instance = DictNodeCache()
        instance.nodes = [Int: SKSpriteNode]()
        return instance
    }
    
    // MARK: NodeCache Methods
    
    func storeNode(_ node: SKSpriteNode, forId id: Int) {
        self.nodes[id] = node
    }
    
    func retrieveNode(id: Int) -> SKSpriteNode? {
        return self.nodes[id]
    }
    
    func removeNode(id: Int) {
        self.nodes[id] = nil
    }
    
    func iter() -> [(Int, SKSpriteNode)] {
        var iter = [(Int, SKSpriteNode)]()
        for id in self.nodes.keys {
            iter.append((id, self.nodes[id]!))
        }
        return iter
    }
}
