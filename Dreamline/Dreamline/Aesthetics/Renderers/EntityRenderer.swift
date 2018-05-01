//
//  EntityRenderer.swift
//  Dreamline
//
//  Created by BeeDream on 4/11/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import SpriteKit

class EntityRenderer: Observer {
    
    // MARK: Private Properties
    
    private var layout: BoardLayout!
    
    private var scene: SKScene!
    private var cache: DictNodeCache!
    
    private var delegate: EntityRendererDelegate!
    
    // MARK: Init
    
    static func make(scene: SKScene, delegate: EntityRendererDelegate) -> EntityRenderer {
        let instance = EntityRenderer()
        instance.scene = scene
        instance.delegate = delegate
        instance.cache = DictNodeCache.make()
        return instance
    }
    
    // MARK: Observer Methods
    
    func observe(event: KernelEvent) {
        switch event {
            
        case .boardEntityAdd(let entity):
            self.addNode(entity: entity)
            
        case .boardEntityRemove(let id):
            self.removeNode(id: id)
            
        case .boardEntityStateUpdate(let id, _, let state):
            if let node = self.cache.retrieveNode(id: id) {
                self.delegate.handleEntityStateChange(state: state, node: node)
            }
            
        case .boardScroll(let distance):
            for (_, entity) in self.cache.iter() {
                entity.position.y -= CGFloat(distance / 2.0) * self.scene.frame.height // @FIXME
            }
            
        case .multiple(let events):
            for bundledEvent in events {
                self.observe(event: bundledEvent)
            }
            
        default:
            break
        }
    }
    
    // MARK: Private Methods
    
    private func addNode(entity: Entity) {
        guard let node = self.delegate.makeNode(entity: entity) else { return }
        
        node.position.y = self.nodePosition(position: entity.position)
        
        scene.addChild(node)
        self.cache.storeNode(node, forId: entity.id)
    }
    
    private func removeNode(id: Int) {
        guard let node = self.cache.retrieveNode(id: id) else { return }
        
        node.removeAllActions()
        node.removeFromParent()
        self.cache.removeNode(id: id)
    }
    
    private func nodePosition(position: Double) -> CGFloat {
        let midY = self.scene.frame.midY
        let offset = self.scene.frame.height * -0.5
        return midY + CGFloat(position) * offset
        //return self.scene.frame.maxY
    }
}

protocol EntityRendererDelegate {
    func makeNode(entity: Entity) -> SKSpriteNode?
    func handleEntityStateChange(state: EntityState, node: SKSpriteNode)
}
