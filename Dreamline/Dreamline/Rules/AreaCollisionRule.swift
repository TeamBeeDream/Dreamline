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
                
            case .entityMoved(let entity, _):
                switch entity.type {
                case .area(let gates):
                    
                    let inArea = self.inArea(playerPosition: self.layout.playerPosition,
                                             areaLowerBound: entity.position - self.layout.distanceBetweenEntities,
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
                    
                default: break
                }
                
            default: break
            }
        }
    }
    
    // MARK: Private Methods
    
    // @NOTE: This only determines if in vertical range of area
    private func inArea(playerPosition: Double,
                        areaLowerBound: Double,
                        areaUpperBound: Double) -> Bool {
        
        // @NOTE: This is a spot check, it only checks if
        // the player is currently in the area
        // So if the player is going fast enough to cross
        // over the entire area this function will return fals
        
        return
            (playerPosition < areaUpperBound) &&
            (playerPosition > areaLowerBound)
    }
}
