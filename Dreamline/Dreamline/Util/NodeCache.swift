//
//  NodeCache.swift
//  Dreamline
//
//  Created by BeeDream on 4/11/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

// @MOVE
protocol TextureCache {
    associatedtype T
    func storeTexture(_ texture: SKTexture, forKey key: T)
    func retrieveTexture(key: T) -> SKTexture?
}

// @MOVE
protocol NodeCache {
    func storeNode(_ node: SKNode, forId id: Int)
    func retrieveNode(id: Int) -> SKNode?
    func removeNode(id: Int)
    func iter() -> [(Int, SKNode)]
}

class DictTextureCache<T: Hashable>: TextureCache {
    
    // MARK: Private Properties
    
    private var textures: [T: SKTexture]!
    
    // MARK: Init
    
    static func make() -> DictTextureCache {
        let instance = DictTextureCache()
        instance.textures = [T: SKTexture]()
        return instance
    }
    
    // MARK: TextureCache Methods
    
    func storeTexture(_ texture: SKTexture, forKey key: T) {
        self.textures[key] =  texture
    }
    
    func retrieveTexture(key: T) -> SKTexture? {
        return self.textures[key]
    }
}

class DictNodeCache: NodeCache {
    
    // MARK: Private Properties
    
    private var nodes: [Int: SKNode]!
    
    // MARK: Init
    
    static func make() -> DictNodeCache {
        let instance = DictNodeCache()
        instance.nodes = [Int: SKNode]()
        return instance
    }
    
    // MARK: NodeCache Methods
    
    func storeNode(_ node: SKNode, forId id: Int) {
        self.nodes[id] = node
    }
    
    func retrieveNode(id: Int) -> SKNode? {
        return self.nodes[id]
    }
    
    func removeNode(id: Int) {
        self.nodes[id] = nil
    }
    
    func iter() -> [(Int, SKNode)] {
        var iter = [(Int, SKNode)]()
        for id in self.nodes.keys {
            iter.append((id, self.nodes[id]!))
        }
        return iter
    }
}
