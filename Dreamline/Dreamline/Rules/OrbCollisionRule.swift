//
//  OrbCollisionRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/11/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class OrbCollisionRule: Rule {
    
    // MARK: Private Properties
    
    private var nearestLane: Int!
    private var layout: BoardLayout!
    
    // MARK: Init
    
    static func make() -> OrbCollisionRule {
        return OrbCollisionRule()
    }
    
    // MARK: Rule Methods
    
    func sync(state: KernelState) {
        self.nearestLane = state.positionState.nearestLane
        self.layout = state.boardState.layout
    }
    
    func decide(events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        
        for event in events {
            switch event {
                
            case .positionUpdated(let position):
                self.nearestLane = position.nearestLane
                
            case .entityMoved(let entity, let prevPosition):
                if entity.state != .none { break }
                
                switch entity.data {
                case .orb(let orbs):
                    if orbs[nearestLane + 1] == .none { break }
                    
                    if Collision.didCrossLine(testPosition: self.layout.playerPosition,
                                              linePosition: entity.position,
                                              lineDelta: entity.position - prevPosition) {
                        instructions.append(.updateEntityState(entity.id, .hit))
                    }
                    
                default: break
                }
                
            default: break
            }
        }
    }
}
