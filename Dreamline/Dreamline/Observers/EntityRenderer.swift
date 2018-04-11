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
    private var cache: NodeCache!
    
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
    
    func setup(state: KernelState) {
        self.layout = state.boardState.layout
        // @TEST
        for (_, entity) in state.boardState.entities {
            if let node = self.delegate.makeNode(entity: entity) {
                self.cache.storeNode(node, forId: entity.id)
            }
        }
    }
    
    func observe(events: [KernelEvent]) {
        for event in events {
            switch event {
                
            case .entityAdded(let entity):
                self.addNode(entity: entity)
                
            case .entityRemoved(let id):
                self.removeNode(id: id)
                
            case .entityStateChanged(let entity):
                if let node = self.cache.retrieveNode(id: entity.id) {
                    self.delegate.handleEntityStateChange(entity: entity, node: node)
                }
                
            case .boardScrolled(_, let delta):
                for (_, entity) in self.cache.iter() {
                    entity.position.y -= CGFloat(delta / 2.0) * self.scene.frame.height // @FIXME
                }
                
            default:
                break
            }
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
    func makeNode(entity: Entity) -> SKNode?
    func handleEntityStateChange(entity: Entity, node: SKNode)
}
