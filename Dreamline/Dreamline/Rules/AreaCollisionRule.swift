//
//  AreaCollisionRule.swift
//  Dreamline
//
//  Created by BeeDream on 4/10/18.
//  Copyright © 2018 Team BeeDream. All rights reserved.
//

import Foundation

class AreaCollisionRule: Rule {
    
    // MARK: Private Properties
    
    private var nearestLane: Int!
    private var layout: BoardLayout!
    
    // MARK: Init
    
    static func make() -> AreaCollisionRule {
        return AreaCollisionRule()
    }
    
    // MARK: Rule Methods
    
    func setup(state: KernelState) {
        self.nearestLane = state.positionState.nearestLane
        self.layout = state.boardState.layout
    }
    
    func mutate(events: inout [KernelEvent],
                instructions: inout [KernelInstruction],
                deltaTime: Double) {
        
        for event in events {
            switch event {
            case .positionUpdated(let position):
                self.nearestLane = position.nearestLane
                
            case .entityMoved(let entity, let prevPosition):
                switch entity.type {
                case .area(let gates):
                    
                    let inArea = Collision.inArea(testPosition: self.layout.playerPosition,
                                                  areaLowerBound: entity.position -     self.layout.distanceBetweenEntities,
                                                  areaUpperBound: entity.position)
                    let inLane = gates[self.nearestLane + 1] // gross
                    
                    switch entity.state {
                    case .over: fallthrough
                    case .none:
                        if inArea && inLane {
                            // @NOTE: I needed a way to have an event trigger every frame
                            // it seems like the easiest way to do that is to have
                            // to send the same instruction over and over again because
                            // an event always follows...
                            instructions.append(.updateEntityState(entity.id, .over))
                        }
                        
                    case .hit: fallthrough
                    case .passed:
                        break
                        
                    }
                    
                    // Check for crossing top of area (leaving area)
                    if Collision.didCrossLine(testPosition: self.layout.playerPosition,
                                                    linePosition: entity.position - self.layout.distanceBetweenEntities,
                                                    lineDelta: entity.position - prevPosition) {
                        instructions.append(.updateEntityState(entity.id, .passed))
                    }
                    
                default: break
                }
                
            default: break
            }
        }
    }
}
