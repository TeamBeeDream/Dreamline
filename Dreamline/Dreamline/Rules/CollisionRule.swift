//
//  CollisionRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/9/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

// @NOTE: Might need to make this more specific
// i.e. BarrierCollisionRule vs AreaCollisionRule
class CollisionRule: Rule {
    
    // MARK: Private Properties
    
    private var layout: BoardLayout!
    private var nearestLane: Int!
    
    // MARK: Init
    
    static func make() -> CollisionRule {
        return CollisionRule()
    }
    
    // MARK: Rule Methods
    
    func setup(state: KernelState) {
        self.layout = state.boardState.layout
        self.nearestLane = state.positionState.nearestLane
    }
    
    func mutate(events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        
        // Iterate through entities and test for collision
        // @NOTE: Should this be here or in the kernel?
        
        for event in events {
            switch event {
                
            case .positionUpdated(let position):
                self.nearestLane = position.nearestLane
                
            case .entityMoved(let entity, let prevPosition):
                if entity.state != .none { continue }
                
                if self.didCross(playerPosition: self.layout.playerPosition,
                                 entityPosition: entity.position,
                                 scrollDistance: entity.position - prevPosition) {
                    // @CLEANUP
                    switch entity.type {
                    case .threshold:
                        instructions.append(.updateEntityState(entity.id, .hit))
                        
                    case .barrier(let gates):
                        let laneIndex = self.nearestLane + 1
                        if gates[laneIndex] {
                            instructions.append(.updateEntityState(entity.id, .passed))
                        } else {
                            instructions.append(.updateEntityState(entity.id, .hit))
                        }
                    }
                }
            
            default:
                break
                
            }
        }
    }
    
    // MARK: Private Methods
    
    private func didCross(playerPosition: Double,
                          entityPosition: Double,
                          scrollDistance: Double) -> Bool {
        
        // @FIXME
        return
            (playerPosition < entityPosition) &&
            (playerPosition > entityPosition - scrollDistance)
    }
}
