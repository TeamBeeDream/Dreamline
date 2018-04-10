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
class LineCollisionRule: Rule {
    
    // MARK: Private Properties
    
    private var layout: BoardLayout!
    private var nearestLane: Int!
    
    // MARK: Init
    
    static func make() -> LineCollisionRule {
        return LineCollisionRule()
    }
    
    // MARK: Rule Methods
    
    func setup(state: KernelState) {
        self.layout = state.boardState.layout
        self.nearestLane = state.positionState.nearestLane
    }
    
    func mutate(events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        
        for event in events {
            switch event {
                
            // @NOTE: This just maintains the state for this rule
            // Might make sense to put it in its own method
            case .positionUpdated(let position):
                self.nearestLane = position.nearestLane
                
            // @NOTE: This is only checking for crossing over entities
            // @TODO: Change the name to better reflect this
            case .entityMoved(let entity, let prevPosition):
                if entity.state != .none { continue }
                
                switch entity.data {
                case .threshold:
                    if Collision.didCrossLine(testPosition: self.layout.playerPosition,
                                                    linePosition: entity.position,
                                                    lineDelta: entity.position - prevPosition) {
                        instructions.append(.updateEntityState(entity.id, .hit))
                    }
                    
                case .barrier(let gates):
                    if Collision.didCrossLine(testPosition: self.layout.playerPosition,
                                                    linePosition: entity.position,
                                                    lineDelta: entity.position - prevPosition) {
                        let laneIndex = self.nearestLane + 1
                        let newState = gates[laneIndex] ? EntityState.passed : EntityState.hit
                        instructions.append(.updateEntityState(entity.id, newState))
                    }
                    
                default: break
                    
                }
            
            default:
                break
                
            }
        }
    }
}
