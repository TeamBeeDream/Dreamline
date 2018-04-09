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
    
    // MARK: Init
    
    static func make() -> CollisionRule {
        return CollisionRule()
    }
    
    // MARK: Rule Methods
    
    func mutate(state: KernelState,
                events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        
        // Iterate through entities and test for collision
        // @NOTE: Should this be here or in the kernel?
        
        for event in events {
            switch event {
                
            case .boardScrolled(let distance):
                for entity in state.boardState.entities.values {
                    if entity.state != .none { continue }
                    
                    if self.didCross(playerPosition: state.boardState.layout.playerPosition,
                                     entityPosition: entity.position,
                                     scrollDistance: distance) {
                        
                        // @CLEANUP
                        switch entity.type {
                        case .threshold:
                            instructions.append(.updateEntityState(entity.id, .hit))
                            
                        case .barrier(let gates):
                            let laneIndex = state.positionState.nearestLane + 1
                            if gates[laneIndex] {
                                instructions.append(.updateEntityState(entity.id, .passed))
                            } else {
                                instructions.append(.updateEntityState(entity.id, .hit))
                            }
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
